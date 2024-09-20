import 'package:churchapp/views/donations/financial/donnation_status.dart';
import 'package:churchapp/views/financial_files/income/anual_chart.dart';
import 'package:churchapp/views/financial_files/income/monthly_chart.dart';
import 'package:churchapp/views/financial_files/revenue_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const Color kDonationColor = Color(0xFF4CAF50);
const Color kCourseColor = Color(0xFF2196F3);
const Color kIncomeColor = Color(0xFFFF9800);
const Color kTotalColor = Color(0xFF9C27B0);
const Color kCourseRevenueColor = Color(0xFF40C4FF);
const Color kOtherIncomeColor = Color(0xFFFFC107);
const Color kTotalIncomeColor = Color(0xFFD500F9);
const Color kBackgroundColor = Color(0xFFF5F5F5);
const Color kDarkGrayColor = Color(0xFF616161);
const Color kDarkBlueColor = Color(0xFF304FFE);
const Color kDarkGreenColor = Color(0xFF00C853);
const Color kDarkOrangeColor = Color(0xFFFF6D00);
const Color kDarkPurpleColor = Color(0xFFAA00FF);

class IncomesScreen extends StatelessWidget {
  final DonationStats donationStats;
  final RevenueService _revenueService = RevenueService();

  IncomesScreen({super.key, required this.donationStats});

  Future<Map<String, double>> _fetchAllRevenues() async {
    try {
      final revenues = await _revenueService.fetchAllRevenues(donationStats);

      final totalCourseRevenue = revenues['totalCourseRevenue'] ?? 0;
      final totalOtherIncome = revenues['totalOverallIncome'] ?? 0;
      final totalDonations = revenues['totalDonations'] ?? 0;

      final totalMonthlyCourseRevenue = revenues['monthlyCourseRevenue'] ?? 0;
      final totalMonthlyOtherIncome = revenues['monthlyOtherIncome'] ?? 0;
      final totalMonthlyDonations = revenues['monthlyDonations'] ?? 0;

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
        backgroundColor: kDonationColor,
      ),
      body: FutureBuilder<Map<String, double>>(
          future: _fetchAllRevenues(),
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

            final totalReceitas = data['totalReceitas'] ?? 0;
            final totalMensalReceitas = data['totalMensalReceitas'] ?? 0;
            final totalBalance = data['totalBalance'] ?? 0;
            final totalMonthlyDonations = data['totalMonthlyDonations'] ?? 0;
            final totalOverallSum = data['totalOverallSum'] ?? 0;
            final totalOverallCourseRevenue =
                data['totalOverallCourseRevenue'] ?? 0;
            final totalMonthlyCourseRevenue =
                data['totalMonthlyCourseRevenue'] ?? 0;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    const SizedBox(height: 16),
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
                  ],
                ),
              ),
            );
          }),
    );
  }
}
