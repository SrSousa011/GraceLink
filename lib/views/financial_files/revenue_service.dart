import 'package:churchapp/views/courses/charts/course_status.dart';
import 'package:churchapp/views/donations/financial/donnation_status.dart';
import 'package:churchapp/views/financial_files/revenue_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class RevenueService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<RevenueData> fetchAllRevenues() async {
    try {
      double totalOthers = await _getTotalOthers();
      double totalDonations = await _getTotalDonations();
      double totalCourses = await _getTotalCourses();

      double totalIncomes = totalOthers + totalDonations + totalCourses;

      return RevenueData(
        totalOthers: totalOthers,
        totalDonations: totalDonations,
        totalCourses: totalCourses,
        totalIncomes: totalIncomes,
      );
    } catch (e) {
      throw Exception('Error fetching all revenues: $e');
    }
  }

  Future<double> _getTotalOthers() async {
    return await _getTotalFromCollection(
        'transactions', 'Rendimento', 'amount');
  }

  Future<double> _getTotalDonations() async {
    return await _getTotalFromCollection('donations', null, 'donationValue');
  }

  Future<double> _getTotalCourses() async {
    return await _getTotalFromCollection('courseRegistration', null, 'price');
  }

  Future<double> _getTotalFromCollection(
      String collection, String? type, String field) async {
    try {
      final query = _firestore.collection(collection);
      final snapshot = type != null
          ? await query.where('type', isEqualTo: type).get()
          : await query.get();

      return snapshot.docs.fold<double>(0.0, (total, doc) {
        double value =
            (doc[field] ?? 0.0) is num ? (doc[field] as num).toDouble() : 0.0;
        return total + value;
      });
    } catch (e) {
      throw Exception('Error fetching total from collection $collection: $e');
    }
  }

  Future<DonationStats> fetchDonationStats() async {
    final snapshot = await _firestore.collection('donations').get();
    double totalDonations = 0.0;
    List<double> monthlyDonations = List.filled(12, 0);

    for (var doc in snapshot.docs) {
      double donationValue = (doc['donationValue'] ?? 0.0) is num
          ? (doc['donationValue'] as num).toDouble()
          : 0.0;
      totalDonations += donationValue;

      final date = (doc['timestamp'] as Timestamp).toDate();
      final month = date.month - 1;
      monthlyDonations[month] += donationValue;
    }

    return DonationStats(
        totalDonation: totalDonations, monthlyDonations: monthlyDonations);
  }

  Future<CoursesStats> fetchCoursesStats() async {
    final snapshot = await _firestore.collection('courseRegistration').get();
    double totalCourses = 0.0;
    List<double> monthlyCourses = List.filled(12, 0);

    for (var doc in snapshot.docs) {
      double price =
          (doc['price'] ?? 0.0) is num ? (doc['price'] as num).toDouble() : 0.0;
      totalCourses += price;

      final date = (doc['registrationDate'] as Timestamp).toDate();
      final month = date.month - 1;
      monthlyCourses[month] += price;
    }

    return CoursesStats(
        totalCourses: totalCourses, monthlyCourses: monthlyCourses);
  }

  Future<RevenueData> fetchData() async {
    final revenueData = await fetchAllRevenues();

    final donationStats = await fetchDonationStats();
    final courseStats = await fetchCoursesStats();

    final monthlyData = await fetchMonthlyRevenues();

    final monthName = RevenueData.getMonthName(DateTime.now().month);

    revenueData.othersPerMonth[monthName] =
        (monthlyData['totalIncomes'] ?? 0.0);
    revenueData.donationsPerMonth[monthName] =
        (donationStats.monthlyDonations[DateTime.now().month - 1]);
    revenueData.coursesPerMonth[monthName] =
        (courseStats.monthlyCourses[DateTime.now().month - 1]);

    return revenueData;
  }

  Future<Map<String, dynamic>> fetchMonthlyRevenues() async {
    try {
      final incomeData = await _fetchIncomeDataPerMonth();
      final donationData =
          await _fetchDonationDataPerMonth(await fetchDonationStats());
      final courseRevenueData = await _fetchCourseRevenueDataPerMonth();

      double totalOthers = incomeData.values.fold(
        0.0,
        (accumulator, item) => accumulator + item,
      );

      double totalDonations = donationData.values.fold(
        0.0,
        (accumulator, item) => accumulator + (item['totalDonations'] ?? 0.0),
      );

      double totalCourses = courseRevenueData.values.fold(
        0.0,
        (accumulator, item) => accumulator + (item['totalCourses'] ?? 0.0),
      );

      return {
        'totalOthers': totalOthers,
        'totalDonations': totalDonations,
        'totalCourses': totalCourses,
      };
    } catch (e) {
      throw Exception('Erro ao buscar receitas mensais: $e');
    }
  }

  Future<Map<String, dynamic>> _fetchDonationDataPerMonth(
      DonationStats donationStats) async {
    Map<String, dynamic> monthlyData = {};

    for (int month = 1; month <= 12; month++) {
      monthlyData[_getMonthName(month)] = {
        'totalDonations': donationStats.monthlyDonations[month - 1],
        'monthlyDonations': donationStats.monthlyDonations[month - 1]
      };
    }

    return monthlyData;
  }

  Future<Map<String, dynamic>> _fetchCourseRevenueDataPerMonth() async {
    final snapshot = await _firestore.collection('courses').get();
    Map<String, double> monthlyCourseRevenue = {};

    for (var doc in snapshot.docs) {
      if (doc.data().containsKey('time')) {
        final date = (doc['time'] as Timestamp).toDate();
        final month = date.month;
        final coursePrice = (doc['price'] ?? 0.0) is num
            ? (doc['price'] as num).toDouble()
            : 0.0;

        final monthName = _getMonthName(month);
        monthlyCourseRevenue[monthName] =
            (monthlyCourseRevenue[monthName] ?? 0.0) + coursePrice;
      } else {
        if (kDebugMode) {
          print(
              'Documento ignorado, campo "courseDate" não encontrado: ${doc.id}');
        }
      }
    }

    return {
      for (int month = 1; month <= 12; month++)
        _getMonthName(month): {
          'totalCourses': monthlyCourseRevenue[_getMonthName(month)] ?? 0.0
        }
    };
  }

  Future<Map<String, double>> _fetchIncomeDataPerMonth() async {
    final snapshot = await _firestore.collection('transactions').get();
    Map<String, double> monthlyIncomeData = {};

    for (var doc in snapshot.docs) {
      if (doc.data().containsKey('transactionDate')) {
        final date = (doc['transactionDate'] as Timestamp).toDate();
        final month = date.month;
        final incomeAmount = (doc['amount'] ?? 0.0) is num
            ? (doc['amount'] as num).toDouble()
            : 0.0;

        monthlyIncomeData[_getMonthName(month)] =
            (monthlyIncomeData[_getMonthName(month)] ?? 0.0) + incomeAmount;
      } else {
        if (kDebugMode) {
          print(
              'Documento ignorado, campo "transactionDate" não encontrado: ${doc.id}');
        }
      }
    }

    return monthlyIncomeData;
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
