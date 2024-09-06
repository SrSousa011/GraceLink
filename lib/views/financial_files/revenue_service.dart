import 'package:churchapp/views/courses/service/courses_service.dart';
import 'package:churchapp/views/donations/financial/donnation_status.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class RevenueService {
  final CoursesService _coursesService = CoursesService();

  Future<Map<String, double>> fetchAllRevenues(
      DonationStats donationStats) async {
    try {
      final donationData = await _fetchDonationData(donationStats);
      final courseRevenueData = await _fetchCourseRevenueData();
      final incomeData = await _fetchIncomeData();

      final totalReceitas = (donationData['totalDonations'] ?? 0) +
          (courseRevenueData['totalOverallCourseRevenue'] ?? 0) +
          (incomeData['totalOverallIncome'] ?? 0);

      final monthlyReceitas = (donationData['monthlyDonations'] ?? 0) +
          (courseRevenueData['monthlyCourseRevenue'] ?? 0) +
          (incomeData['monthlyOtherIncome'] ?? 0);

      return {
        'totalReceita': totalReceitas,
        'monthlyReceita': monthlyReceitas,
        'totalDonations': donationData['totalDonations'] ?? 0,
        'monthlyDonations': donationData['monthlyDonations'] ?? 0,
        'totalCourseRevenue':
            courseRevenueData['totalOverallCourseRevenue'] ?? 0,
        'monthlyCourseRevenue': courseRevenueData['monthlyCourseRevenue'] ?? 0,
        'totalOverallIncome': incomeData['totalOverallIncome'] ?? 0,
        'monthlyOtherIncome': incomeData['monthlyOtherIncome'] ?? 0,
      };
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching all revenues: $e');
      }
      return {
        'totalReceita': 0.0,
        'monthlyReceita': 0.0,
        'totalDonations': 0.0,
        'monthlyDonations': 0.0,
        'totalCourseRevenue': 0.0,
        'monthlyCourseRevenue': 0.0,
        'totalOtherIncome': 0.0,
        'monthlyOtherIncome': 0.0,
      };
    }
  }

  // Fetch de outras rendas (income)
  Future<Map<String, double>> _fetchIncomeData() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('User not authenticated');
    }

    try {
      final now = DateTime.now();
      final startOfYear = DateTime(now.year, 1, 1);
      final endOfYear = DateTime(now.year + 1, 1, 1);
      final startOfMonth = DateTime(now.year, now.month, 1);
      final endOfMonth = DateTime(now.year, now.month + 1, 1);

      final querySnapshot = await firestore
          .collection('transactions')
          .where('createdBy', isEqualTo: user.uid)
          .where('category', isEqualTo: 'income')
          .get();

      double totalAnnualSum = 0;
      double monthlyIncomeSum = 0;

      for (final doc in querySnapshot.docs) {
        final data = doc.data();
        final amount = (data['amount'] as num).toDouble();
        final createdAt = (data['createdAt'] as Timestamp).toDate();

        if (createdAt.isAfter(startOfYear) && createdAt.isBefore(endOfYear)) {
          totalAnnualSum += amount;
        }

        if (createdAt.isAfter(startOfMonth) && createdAt.isBefore(endOfMonth)) {
          monthlyIncomeSum += amount;
        }
      }

      return {
        'totalOverallIncome': totalAnnualSum,
        'monthlyOtherIncome': monthlyIncomeSum,
      };
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching income data: $e');
      }
      return {
        'totalOverallIncome': 0,
        'monthlyOtherIncome': 0,
      };
    }
  }

  // Fetch de receitas dos cursos
  Future<Map<String, double>> _fetchCourseRevenueData() async {
    try {
      final totalRevenue =
          (await _coursesService.calculateTotalRevenue()) as num;
      final monthlyRevenue =
          (await _coursesService.calculateMonthlyRevenue()) as num;

      return {
        'totalOverallCourseRevenue': totalRevenue.toDouble(),
        'monthlyCourseRevenue': monthlyRevenue.toDouble(),
      };
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching course revenue data: $e');
      }
      return {
        'totalOverallCourseRevenue': 0,
        'monthlyCourseRevenue': 0,
      };
    }
  }

  // Fetch de doações
  Future<Map<String, double>> _fetchDonationData(
      DonationStats donationStats) async {
    try {
      return {
        'totalDonations': donationStats.totalDonation.toDouble(),
        'monthlyDonations': donationStats.monthlyDonation.toDouble(),
      };
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching donation data: $e');
      }
      return {
        'totalDonations': 0,
        'monthlyDonations': 0,
      };
    }
  }
}
