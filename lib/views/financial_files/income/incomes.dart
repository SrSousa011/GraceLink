import 'package:churchapp/views/donations/financial/donnation_status.dart';
import 'package:churchapp/views/financial_files/income/anual_chart.dart';
import 'package:churchapp/views/financial_files/income/chart_colors.dart';
import 'package:churchapp/views/financial_files/income/monthly_chart.dart';
import 'package:churchapp/views/financial_files/revenue_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class IncomesScreen extends StatelessWidget {
  final DonationStats donationStats;
  final RevenueService _revenueService = RevenueService();

  IncomesScreen({super.key, required this.donationStats});

  Future<Map<String, double>> _fetchAllRevenues() async {
    try {
      final revenues = await _revenueService.fetchAllRevenues();

      final totalCourseRevenue =
          (revenues['courseRevenues']['totalCourseRevenue'] ?? 0.0) as double;
      final totalOtherIncome =
          (revenues['income']['totalIncome'] ?? 0.0) as double;
      final totalDonations =
          (revenues['donations']['totalDonation'] ?? 0.0) as double;

      final totalMonthlyCourseRevenue =
          (revenues['courseRevenues']['monthlyCourseRevenue'] ?? 0.0) as double;
      final totalMonthlyOtherIncome =
          (revenues['income']['monthlyIncome'] ?? 0.0) as double;
      final totalMonthlyDonations =
          (revenues['donations']['monthlyDonations'] ?? 0.0) as double;

      final result = {
        'totalReceitas': totalCourseRevenue + totalOtherIncome + totalDonations,
        'totalMensalReceitas': totalMonthlyCourseRevenue +
            totalMonthlyOtherIncome +
            totalMonthlyDonations,
        'totalBalance': totalDonations,
        'totalMonthlyDonations': totalMonthlyDonations,
        'totalOverallSum': totalOtherIncome,
        'monthlyOtherIncome': totalMonthlyOtherIncome,
        'totalOverallCourseRevenue': totalCourseRevenue,
        'totalMonthlyCourseRevenue': totalMonthlyCourseRevenue,
      };

      return result;
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao buscar receitas: $e');
      }
      return {
        'totalReceitas': 0.0,
        'totalMensalReceitas': 0.0,
        'totalBalance': 0.0,
        'totalMonthlyDonations': 0.0,
        'totalOverallSum': 0.0,
        'monthlyOtherIncome': 0.0,
        'totalOverallCourseRevenue': 0.0,
        'totalMonthlyCourseRevenue': 0.0,
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receitas'),
        backgroundColor: IncomeChartColors.kDonationColor,
      ),
      body: FutureBuilder<Map<String, double>>(
        future: _fetchAllRevenues(), // Assegurando que o tipo está correto
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('Receitas não encontradas.'));
          }

          final data = snapshot.data!;

          final totalReceitas = data['totalReceitas'] ?? 0.0;
          final totalMensalReceitas = data['totalMensalReceitas'] ?? 0.0;
          final totalBalance = data['totalBalance'] ?? 0.0;
          final totalMonthlyDonations = data['totalMonthlyDonations'] ?? 0.0;
          final totalOverallSum = data['totalOverallSum'] ?? 0.0;
          final totalOverallCourseRevenue =
              data['totalOverallCourseRevenue'] ?? 0.0;
          final totalMonthlyCourseRevenue =
              data['totalMonthlyCourseRevenue'] ?? 0.0;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 400,
                    child: MonthlyIncomeChart(
                      totalMonthlyReceita: totalMensalReceitas,
                      totalMonthlyIncome: totalOverallSum,
                      totalMonthlyCourseRevenue: totalMonthlyCourseRevenue,
                      totalMonthlyDonations: totalMonthlyDonations,
                      isDarkMode:
                          Theme.of(context).brightness == Brightness.dark,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 410,
                    child: AnnualIncomeChart(
                      totalReceita: totalReceitas,
                      totalDonations: totalBalance,
                      totalCourseRevenue: totalOverallCourseRevenue,
                      totallIncome: totalOverallSum,
                      isDarkMode:
                          Theme.of(context).brightness == Brightness.dark,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
