import 'package:churchapp/views/donations/financial/donnation_status.dart';
import 'package:churchapp/views/financial_files/revenue_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class RevenueService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<RevenueData> fetchAllRevenues() async {
    try {
      double totalIncome = await _getTotalIncome();
      double totalDonations = await _getTotalDonations();
      double totalCourse = await _getTotalCourse();

      double totalRevenue = totalIncome + totalDonations + totalCourse;

      return RevenueData(
        totalOthers: totalIncome,
        totalDonations: totalDonations,
        totalCourseRevenue: totalCourse,
        totalRevenue: totalRevenue,
      );
    } catch (e) {
      throw Exception('Error fetching all revenues: $e');
    }
  }

  Future<double> _getTotalIncome() async {
    return await _getTotalFromCollection(
        'transactions', 'Rendimento', 'amount');
  }

  Future<double> _getTotalDonations() async {
    return await _getTotalFromCollection('donations', null, 'donationValue');
  }

  Future<double> _getTotalCourse() async {
    return await _getTotalFromCollection('courses', null, 'price');
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
        return total + value; // Ensure adding double values
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
      final month = date.month - 1; // Index adjustment for the list
      monthlyDonations[month] += donationValue; // Accumulate donations by month
    }

    return DonationStats(
        totalDonation: totalDonations, monthlyDonations: monthlyDonations);
  }

  Future<RevenueData> fetchData() async {
    // Buscar todas as receitas (doações totais, renda e cursos)
    final revenueData = await fetchAllRevenues();

    // Buscar estatísticas de doação
    final donationStats = await fetchDonationStats();

    // Buscar receitas mensais
    final monthlyData = await fetchMonthlyRevenues();

    // Preencher o mapa incomePerMonth
    final monthName = RevenueData.getMonthName(DateTime.now().month);

    revenueData.incomePerMonth[monthName] = (monthlyData['totalIncome'] ?? 0.0);
    revenueData.donationsPerMonth[monthName] =
        (donationStats.monthlyDonations[DateTime.now().month - 1]);
    revenueData.courseRevenuePerMonth[monthName] =
        (monthlyData['totalCourseRevenue'] ?? 0.0);

    double totalMonthlyRevenue =
        (revenueData.incomePerMonth[monthName] ?? 0.0) +
            (revenueData.donationsPerMonth[monthName] ?? 0.0) +
            (revenueData.courseRevenuePerMonth[monthName] ?? 0.0);

    // Logs de depuração detalhados
    if (kDebugMode) {
      print('Fetched revenue data: $revenueData');
      print('Total Income: ${revenueData.totalOthers}');
      print('Total Donations: ${revenueData.totalDonations}');
      print('Total Course Revenue: ${revenueData.totalCourseRevenue}');
      print('Total Monthly Income: ${monthlyData['totalIncome'] ?? 0.0}');
      print(
          'Total Monthly Donations: ${donationStats.monthlyDonations[DateTime.now().month - 1]}');
      print(
          'Total Monthly Course Revenue: ${monthlyData['totalCourseRevenue'] ?? 0.0}');
      print(
          'Calculated Total Monthly Revenue: $totalMonthlyRevenue'); // Corrigido
    }

    return revenueData;
  }

  Future<Map<String, dynamic>> fetchMonthlyRevenues() async {
    try {
      // Chama as funções para obter dados mensais
      final incomeData = await _fetchIncomeDataPerMonth();
      final donationData = await _fetchDonationDataPerMonth(
          await fetchDonationStats()); // Chame fetchDonationStats
      final courseRevenueData = await _fetchCourseRevenueDataPerMonth();

      // Totaliza as receitas mensais
      double totalIncome =
          incomeData.values.fold(0.0, (sum, item) => sum + item);
      double totalDonations = donationData.values.fold(
          0.0,
          (sum, item) =>
              sum + (item['totalDonations'] ?? 0.0)); // Corrigido aqui
      double totalCourseRevenue = courseRevenueData.values.fold(
          0.0,
          (sum, item) =>
              sum + (item['totalCourseRevenue'] ?? 0.0)); // Corrigido aqui

      return {
        'totalIncome': totalIncome,
        'totalDonations': totalDonations,
        'totalCourseRevenue': totalCourseRevenue,
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
        // Verifique se o campo existe
        final date = (doc['time'] as Timestamp).toDate();
        final month = date.month; // Obter o mês (1 a 12)
        final coursePrice = (doc['price'] ?? 0.0) is num
            ? (doc['price'] as num).toDouble()
            : 0.0;

        // Acumular receita por mês
        final monthName = _getMonthName(month);
        monthlyCourseRevenue[monthName] =
            (monthlyCourseRevenue[monthName] ?? 0.0) + coursePrice;
      } else {
        print(
            'Documento ignorado, campo "courseDate" não encontrado: ${doc.id}');
      }
    }

    // Retornar o total de receita por mês
    return {
      for (int month = 1; month <= 12; month++)
        _getMonthName(month): {
          'totalCourseRevenue':
              monthlyCourseRevenue[_getMonthName(month)] ?? 0.0
        }
    };
  }

  Future<Map<String, double>> _fetchIncomeDataPerMonth() async {
    final snapshot = await _firestore.collection('transactions').get();
    Map<String, double> monthlyIncomeData = {};

    for (var doc in snapshot.docs) {
      if (doc.data().containsKey('transactionDate')) {
        final date = (doc['transactionDate'] as Timestamp).toDate();
        final month = date.month; // O mês vai de 1 a 12
        final incomeAmount = (doc['amount'] ?? 0.0) is num
            ? (doc['amount'] as num).toDouble()
            : 0.0;

        monthlyIncomeData[_getMonthName(month)] =
            (monthlyIncomeData[_getMonthName(month)] ?? 0.0) + incomeAmount;
      } else {
        print(
            'Documento ignorado, campo "transactionDate" não encontrado: ${doc.id}');
      }
    }

    return monthlyIncomeData; // Deve retornar um Map
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
    return monthNames[month - 1]; // Aqui, month é um int
  }
}
