import 'dart:convert';

import 'package:churchapp/views/courses/service/courses_service.dart';
import 'package:churchapp/views/donations/donnation_service.dart';
import 'package:churchapp/views/donations/financial/donnation_status.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RevenueService {
  final CoursesService _coursesService = CoursesService();
  static const Duration cacheDuration = Duration(hours: 1);

  Future<Map<String, double>> fetchAllRevenues() async {
    try {
      final cacheData = await _getCacheData('allRevenues');
      if (cacheData != null) {
        return Map<String, double>.from(cacheData);
      }

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final donationStats = await _fetchDonationStats();
      final courseRevenueData = await _fetchAllCourseRevenueData();
      final incomeData = await _fetchAllIncomeData();

      final allRevenues = {
        'totalDonations': donationStats.totalDonation,
        'totalCourseRevenue': courseRevenueData['totalCourseRevenue'] ?? 0.0,
        'totalIncome': incomeData['totalIncome'] ?? 0.0,
      };

      // Cache the data
      await _setCacheData('allRevenues', allRevenues);

      return allRevenues;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching all revenues: $e');
      }
      return {
        'totalDonations': 0.0,
        'totalCourseRevenue': 0.0,
        'totalIncome': 0.0,
      };
    }
  }

  Future<Map<String, Map<String, double>>> fetchMonthlyRevenues(
      DonationStats donationStats) async {
    try {
      final cacheData = await _getCacheData('monthlyRevenues');
      if (cacheData != null) {
        return Map<String, Map<String, double>>.from(cacheData);
      }

      final donationData = await _fetchDonationDataPerMonth(donationStats);
      final courseRevenueData = await _fetchCourseRevenueDataPerMonth();
      final incomeData = await _fetchIncomeDataPerMonth();

      Map<String, Map<String, double>> monthlyRevenues = {};

      for (int month = 1; month <= 12; month++) {
        final monthName = _getMonthName(month);

        final totalReceitas =
            (donationData[monthName]?['totalDonations'] ?? 0) +
                (courseRevenueData[monthName]?['totalCourseRevenue'] ?? 0) +
                (incomeData[monthName]?['totalIncome'] ?? 0);

        monthlyRevenues[monthName] = {
          'totalReceitas': totalReceitas,
          'totalDonations': donationData[monthName]?['totalDonations'] ?? 0,
          'monthlyDonations': donationData[monthName]?['monthlyDonations'] ?? 0,
          'totalCourseRevenue':
              courseRevenueData[monthName]?['totalCourseRevenue'] ?? 0,
          'totalIncome': incomeData[monthName]?['totalIncome'] ?? 0,
        };
      }

      await _setCacheData('monthlyRevenues', monthlyRevenues);

      return monthlyRevenues;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching monthly revenues: $e');
      }
      return {
        for (int month = 1; month <= 12; month++)
          _getMonthName(month): {
            'totalReceitas': 0.0,
            'totalDonations': 0.0,
            'monthlyDonations': 0.0,
            'totalCourseRevenue': 0.0,
            'totalIncome': 0.0,
          }
      };
    }
  }

  Future<Map<String, dynamic>?> _getCacheData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final cachedString = prefs.getString(key);

    if (cachedString != null) {
      final cachedData = json.decode(cachedString) as Map<String, dynamic>;
      final cacheTimestamp = cachedData['timestamp'] as int;
      final cacheAge = DateTime.now().millisecondsSinceEpoch - cacheTimestamp;

      if (cacheAge < cacheDuration.inMilliseconds) {
        return cachedData['data'] as Map<String, dynamic>;
      }
    }
    return null;
  }

  Future<void> _setCacheData(String key, Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    final cachePayload = json.encode({
      'data': data,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });

    await prefs.setString(key, cachePayload);
  }

  Future<DonationStats> _fetchDonationStats() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('donations')
          .where('userId', isEqualTo: user.uid)
          .get();

      List<Donation> donations = querySnapshot.docs.map((doc) {
        final data = doc.data();

        double amount = 0.0;
        if (data['donationValue'] is num) {
          amount = (data['donationValue'] as num).toDouble();
        } else if (data['donationValue'] is String) {
          amount = double.tryParse(data['donationValue']) ?? 0.0;
        } else {
          if (kDebugMode) {
            print(
                'Unexpected type for amount: ${data['donationValue'].runtimeType}');
          }
        }

        return Donation.fromMap({...data, 'donationValue': amount});
      }).toList();

      return DonationStats.fromDonations(donations);
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching donation stats: $e');
      }
      return DonationStats(
          totalDonation: 0.0, monthlyDonations: List.filled(12, 0.0));
    }
  }

  Future<Map<String, double>> _fetchAllCourseRevenueData() async {
    try {
      final totalCourseRevenue =
          await _coursesService.calculateMonthlyRevenue();

      return {
        'totalCourseRevenue': totalCourseRevenue,
      };
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching course revenue data: $e');
      }
      return {'totalCourseRevenue': 0.0};
    }
  }

  Future<Map<String, double>> _fetchAllIncomeData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    try {
      double totalIncome = 0.0;

      final querySnapshot = await FirebaseFirestore.instance
          .collection('transactions')
          .where('createdBy', isEqualTo: user.uid)
          .where('type', isEqualTo: 'Rendimento')
          .get();

      for (final doc in querySnapshot.docs) {
        final amount = (doc.data()['amount'] as num).toDouble();
        totalIncome += amount;
      }

      return {'totalIncome': totalIncome};
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching income data: $e');
      }
      return {'totalIncome': 0.0};
    }
  }

  Future<Map<String, Map<String, double>>> _fetchIncomeDataPerMonth() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('User not authenticated');
    }

    try {
      final now = DateTime.now();
      final startOfYear = DateTime(now.year, 1, 1);
      final endOfYear = DateTime(now.year + 1, 1, 1);

      Map<String, double> incomePerMonth = {
        for (int month = 1; month <= 12; month++) _getMonthName(month): 0.0,
      };

      final querySnapshot = await firestore
          .collection('transactions')
          .where('createdBy', isEqualTo: user.uid)
          .where('type', isEqualTo: 'Rendimento')
          .get();

      for (final doc in querySnapshot.docs) {
        final amount = (doc.data()['amount'] as num).toDouble();
        final createdAt = (doc.data()['createdAt'] as Timestamp).toDate();

        if (createdAt.isAfter(startOfYear) && createdAt.isBefore(endOfYear)) {
          final monthName = _getMonthName(createdAt.month);
          incomePerMonth[monthName] = (incomePerMonth[monthName] ?? 0) + amount;
        }
      }

      return {
        for (int month = 1; month <= 12; month++)
          _getMonthName(month): {
            'totalIncome': incomePerMonth[_getMonthName(month)] ?? 0.0,
          }
      };
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching income data per month: $e');
      }
      return {
        for (int month = 1; month <= 12; month++)
          _getMonthName(month): {
            'totalIncome': 0.0,
          }
      };
    }
  }

  Future<Map<String, Map<String, double>>>
      _fetchCourseRevenueDataPerMonth() async {
    try {
      double totalCourseRevenue =
          await _coursesService.calculateMonthlyRevenue();

      return {
        for (int month = 1; month <= 12; month++)
          _getMonthName(month): {
            'totalCourseRevenue': totalCourseRevenue,
          }
      };
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching course revenue data per month: $e');
      }
      return {
        for (int month = 1; month <= 12; month++)
          _getMonthName(month): {
            'totalCourseRevenue': 0.0,
          }
      };
    }
  }

  Future<Map<String, Map<String, double>>> _fetchDonationDataPerMonth(
      DonationStats donationStats) async {
    try {
      Map<String, Map<String, double>> donationDataPerMonth = {
        for (int month = 1; month <= 12; month++)
          _getMonthName(month): {
            'totalDonations': 0.0,
            'monthlyDonations': 0.0,
          },
      };

      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception('User not authenticated');
      }

      final querySnapshot = await FirebaseFirestore.instance
          .collection('donations')
          .where('userId', isEqualTo: user.uid)
          .get();

      for (final doc in querySnapshot.docs) {
        final data = doc.data();
        if (data['timestamp'] != null && data['timestamp'] is Timestamp) {
          final createdAt = (data['timestamp'] as Timestamp).toDate();
          final month = createdAt.month;

          double amount = 0.0;
          if (data['donationValue'] is num) {
            amount = (data['donationValue'] as num).toDouble();
          } else if (data['donationValue'] is String) {
            amount = double.tryParse(data['donationValue']) ?? 0.0;
          }

          donationDataPerMonth[_getMonthName(month)]!['totalDonations'] =
              (donationDataPerMonth[_getMonthName(month)]!['totalDonations'] ??
                      0.0) +
                  amount;

          donationDataPerMonth[_getMonthName(month)]!['monthlyDonations'] =
              (donationDataPerMonth[_getMonthName(month)]![
                          'monthlyDonations'] ??
                      0.0) +
                  amount;
        } else {
          if (kDebugMode) {
            print(
                'createdAt is either null or not a Timestamp: ${data['createdAt']}');
          }
        }
      }

      return donationDataPerMonth;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching donation data per month: $e');
      }
      return {
        for (int month = 1; month <= 12; month++)
          _getMonthName(month): {
            'totalDonations': 0.0,
            'monthlyDonations': 0.0,
          }
      };
    }
  }

  Future<Map<String, dynamic>> fetchCurrentAndTotalRevenue() async {
    try {
      final allRevenues = await fetchAllRevenues();

      final donationStats = await _fetchDonationStats();
      final monthlyRevenues = await fetchMonthlyRevenues(donationStats);

      final currentMonthName = _getMonthName(DateTime.now().month);

      final currentMonthData = monthlyRevenues[currentMonthName];

      final currentDonations = currentMonthData?['totalDonations'] ?? 0.0;
      final currentCourseRevenue =
          currentMonthData?['totalCourseRevenue'] ?? 0.0;
      final currentIncome = currentMonthData?['totalIncome'] ?? 0.0;
      final monthlyTotalRevenue =
          currentDonations + currentCourseRevenue + currentIncome;

      final totalRevenue = allRevenues['totalDonations']! +
          allRevenues['totalCourseRevenue']! +
          allRevenues['totalIncome']!;

      return {
        'totalRevenue': totalRevenue,
        'currentDonations': currentDonations,
        'currentCourseRevenue': currentCourseRevenue,
        'currentIncome': currentIncome,
        'monthlyTotalRevenue': monthlyTotalRevenue,
      };
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching current and total revenue: $e');
      }
      return {
        'totalRevenue': 0.0,
        'currentDonations': 0.0,
        'currentCourseRevenue': 0.0,
        'currentIncome': 0.0,
        'monthlyTotalRevenue': 0.0,
      };
    }
  }

  String _getMonthName(int month) {
    const monthNames = [
      'Janeiro',
      'Fevereiro',
      'Março',
      'Abril',
      'Maio',
      'Junho',
      'Julho',
      'Agosto',
      'Setembro',
      'Outubro',
      'Novembro',
      'Dezembro'
    ];
    return monthNames[month - 1];
  }
}
