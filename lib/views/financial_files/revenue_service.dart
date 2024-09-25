import 'package:churchapp/views/courses/service/courses_service.dart';
import 'package:churchapp/views/donations/donnation_service.dart';
import 'package:churchapp/views/donations/financial/donnation_status.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class RevenueService {
  final CoursesService _coursesService = CoursesService();

  /// Fetch all revenues (donations, course revenues, and income).
  Future<Map<String, dynamic>> fetchAllRevenues() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final donationStats = await _fetchDonationStats();
      final courseRevenueData = await _fetchAllCourseRevenueData();
      final incomeData = await _fetchAllIncomeData();

      return {
        'donations': donationStats,
        'courseRevenues': courseRevenueData,
        'income': incomeData,
      };
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching all revenues: $e');
      }
      return {
        'donations': {
          'totalDonation': 0.0,
          'monthlyDonations': List.filled(12, 0.0)
        },
        'courseRevenues': {'totalCourseRevenue': 0.0},
        'income': {'totalIncome': 0.0},
      };
    }
  }

  /// Fetch donation stats for the authenticated user.
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

      return DonationStats.fromDonations(querySnapshot.docs.cast<Donation>());
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching donation stats: $e');
      }
      return DonationStats(
          totalDonation: 0.0, monthlyDonations: List.filled(12, 0.0));
    }
  }

  /// Fetch total course revenue data.
  Future<Map<String, double>> _fetchAllCourseRevenueData() async {
    try {
      Map<String, double> courseRevenuePerMonth = (await _coursesService
          .calculateMonthlyRevenue()) as Map<String, double>;
      double totalCourseRevenue =
          courseRevenuePerMonth.values.reduce((a, b) => a + b);

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

  /// Fetch total income data for the authenticated user.
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
        final data = doc.data();
        final amount = (data['amount'] as num).toDouble();
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

  /// Fetch monthly revenues for donations, courses, and income.
  Future<Map<String, Map<String, double>>> fetchMonthlyRevenues(
      DonationStats donationStats) async {
    try {
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
          'totalCourseRevenue':
              courseRevenueData[monthName]?['totalCourseRevenue'] ?? 0,
          'totalIncome': incomeData[monthName]?['totalIncome'] ?? 0,
        };
      }

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
            'totalCourseRevenue': 0.0,
            'totalIncome': 0.0,
          }
      };
    }
  }

  /// Fetch income data per month for the authenticated user.
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
        final data = doc.data();
        final amount = (data['amount'] as num).toDouble();
        final createdAt = (data['createdAt'] as Timestamp).toDate();

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

  /// Fetch course revenue data per month.
  Future<Map<String, Map<String, double>>>
      _fetchCourseRevenueDataPerMonth() async {
    try {
      Map<String, double> courseRevenuePerMonth = (await _coursesService
          .calculateMonthlyRevenue()) as Map<String, double>;

      return {
        for (int month = 1; month <= 12; month++)
          _getMonthName(month): {
            'totalCourseRevenue':
                courseRevenuePerMonth[_getMonthName(month)] ?? 0.0,
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

  /// Fetch donation data per month from DonationStats.
  Future<Map<String, Map<String, double>>> _fetchDonationDataPerMonth(
      DonationStats donationStats) async {
    try {
      Map<String, Map<String, double>> donationDataPerMonth = {};
      for (int month = 1; month <= 12; month++) {
        donationDataPerMonth[_getMonthName(month)] = {
          'totalDonations': donationStats.monthlyDonations[month - 1],
        };
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
          }
      };
    }
  }

  /// Get the name of the month based on the month number.
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
