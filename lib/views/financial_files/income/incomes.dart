import 'package:churchapp/views/donations/financial/donnation_status.dart';
import 'package:churchapp/views/financial_files/income/anual_chart.dart';
import 'package:churchapp/views/financial_files/income/monthly_chart.dart';
import 'package:churchapp/views/financial_files/income/overall_chart.dart';
import 'package:churchapp/views/financial_files/revenue_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Definindo cores principais
const Color kDonationColor = Color(0xFF4CAF50); // Verde para doações
const Color kCourseColor = Color(0xFF2196F3); // Azul para cursos
const Color kIncomeColor = Color(0xFFFF9800); // Laranja para outros rendimentos
const Color kTotalColor = Color(0xFF9C27B0); // Roxo para o total
const Color kCourseRevenueColor =
    Color(0xFF40C4FF); // Azul brilhante para receita de cursos
const Color kOtherIncomeColor =
    Color(0xFFFFC107); // Amarelo para outros tipos de receita
const Color kTotalIncomeColor =
    Color(0xFFD500F9); // Rosa fluorescente para receita total
const Color kBackgroundColor = Color(0xFFF5F5F5); // Branco gelo para o fundo
const Color kDarkGrayColor =
    Color(0xFF616161); // Cinza médio para textos ou ícones
const Color kDarkBlueColor = Color(0xFF304FFE); // Azul royal para destaques
const Color kDarkGreenColor =
    Color(0xFF00C853); // Verde brilhante para botões ou gráficos
const Color kDarkOrangeColor =
    Color(0xFFFF6D00); // Laranja vibrante para avisos
const Color kDarkPurpleColor =
    Color(0xFFAA00FF); // Roxo intenso para contrastes

class IncomesScreen extends StatelessWidget {
  final DonationStats donationStats;
  final RevenueService _revenueService = RevenueService();

  IncomesScreen({super.key, required this.donationStats});

  Future<Map<String, double>> _fetchAllRevenues() async {
    try {
      final revenues = await _revenueService.fetchAllRevenues(donationStats);

      final result = {
        'totalReceitas': (revenues['totalDonations'] as num?)?.toDouble() ??
            0.0 + (revenues['totalCourse'] as num?)!.toDouble(),
        'totalMensalReceitas':
            (revenues['monthlyDonations'] as num?)?.toDouble() ??
                0.0 + (revenues['monthlyCourse'] as num?)!.toDouble(),
        'totalBalance': (revenues['totalDonations'] as num?)?.toDouble() ?? 0.0,
        'totalMonthlyDonations':
            (revenues['monthlyDonations'] as num?)?.toDouble() ?? 0.0,
        'totalOverallSum': (revenues['totalDonations'] as num?)?.toDouble() ??
            0.0 + (revenues['totalCourse'] as num?)!.toDouble(),
        'totalOverallCourseRevenue':
            (revenues['totalCourse'] as num?)?.toDouble() ?? 0.0,
        'totalMonthlyCourseRevenue':
            (revenues['monthlyCourse'] as num?)?.toDouble() ?? 0.0,
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

            // Use os valores convertidos para double
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
                      height: 500,
                      child: OverallIncomeChart(
                        totalOverallReceita: totalReceitas,
                        totalOverallSum: totalOverallSum,
                        totalOverallCourseRevenue: totalOverallCourseRevenue,
                        totalOverallDonations: totalBalance,
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
