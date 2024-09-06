import 'package:churchapp/views/courses/service/courses_service.dart';
import 'package:churchapp/views/donations/financial/donnation_status.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class RevenueService {
  final CoursesService _coursesService = CoursesService();

  Future<Map<String, double>> fetchAllRevenues(
      DonationStats donationStats) async {
    final totalReceitas = await _fetchDonationData(donationStats);
    final monthlyReceitas = await _fetchDonationData(donationStats);

    final monthlyCourseRevenue = await _fetchCourseRevenueData();
    final courseRevenue = await _fetchCourseRevenueData();

    final monthlyOtherIncome = await _fetchIncomeData();
    final otherIncome = await _fetchIncomeData();

    return {
      'monthlyDonations': monthlyReceitas['monthlyDonations'] ?? 0,
      'totalDonations': totalReceitas['totalDonations'] ?? 0,
      'monthlyCourse': monthlyCourseRevenue['monthlyCourseRevenue'] ?? 0,
      'totalCourse': courseRevenue['totalOverallCourseRevenue'] ?? 0,
      'monthlyOtherIncome': monthlyOtherIncome['monthlyOtherIncome'] ?? 0,
      'totalOtherIncome': otherIncome['totalOverallIncome'] ?? 0,
    };
  }

  // Fetch de outras rendas (income)
  Future<Map<String, double?>> _fetchIncomeData() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('User not authenticated');
    }

    try {
      final now = DateTime.now();

      // Definir o início e o fim do ano atual
      final startOfYear = DateTime(now.year, 1, 1);
      final endOfYear = DateTime(now.year + 1, 1, 1);

      // Definir o início e o fim do mês atual
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

        // Calcular a receita anual
        if (createdAt.isAfter(startOfYear) && createdAt.isBefore(endOfYear)) {
          totalAnnualSum += amount;
        }

        // Calcular a receita do mês atual
        if (createdAt.isAfter(startOfMonth) && createdAt.isBefore(endOfMonth)) {
          monthlyIncomeSum += amount;
        }
      }

      // Print dos valores calculados

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
  Future<Map<String, double?>> _fetchCourseRevenueData() async {
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
  Future<Map<String, double?>> _fetchDonationData(
      DonationStats donationStats) async {
    try {
      return {
        'totalDonations': donationStats.totalDonnation.toDouble(),
        'monthlyDonations': donationStats.monthlyDonnation.toDouble(),
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
