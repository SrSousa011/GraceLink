import 'package:churchapp/views/courses/service/courses_service.dart';
import 'package:churchapp/views/donations/financial/donnation_status.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  final CoursesService _coursesService = CoursesService();

  IncomesScreen({super.key, required this.donationStats});

  Future<Map<String, double>> _fetchAnnualIncomeData() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('User not authenticated');
    }

    final now = DateTime.now();
    final startOfYear = DateTime(now.year, 1, 1);
    final endOfYear = DateTime(now.year + 1, 1, 1);

    final querySnapshot = await firestore
        .collection('transactions')
        .where('createdBy', isEqualTo: user.uid)
        .where('category', isEqualTo: 'income')
        .get();

    double totalAnnualSum = 0;

    for (final doc in querySnapshot.docs) {
      final data = doc.data();
      final amount = (data['amount'] as num).toDouble();
      final createdAt = (data['createdAt'] as Timestamp).toDate();

      if (createdAt.isAfter(startOfYear) && createdAt.isBefore(endOfYear)) {
        totalAnnualSum += amount;
      }
    }

    return {
      'totalOverallSum': totalAnnualSum,
    };
  }

  Future<Map<String, double>> _fetchCourseRevenueData() async {
    try {
      final totalRevenue = await _coursesService.calculateTotalRevenue();
      final monthlyRevenue = await _coursesService.calculateMonthlyRevenue();

      return {
        'totalOverallCourseRevenue': totalRevenue,
        'totalMonthlyCourseRevenue': monthlyRevenue,
      };
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching course revenue data: $e');
      }
      rethrow;
    }
  }

  Future<Map<String, double>> _fetchAnnualDonationData() async {
    try {
      return {
        'totalDonations': donationStats.totalDonnation,
        'monthlyDonnations': donationStats.monthlyDonnation,
      };
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching annual donation data: $e');
      }
      rethrow;
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
        future: Future.wait([
          _fetchAnnualIncomeData(),
          _fetchCourseRevenueData(),
          _fetchAnnualDonationData(),
        ]).then((results) {
          final incomeData = results[0];
          final courseRevenueData = results[1];
          final donationData = results[2];

          final totalReceitas = donationData['totalDonations']! +
              incomeData['totalOverallSum']! +
              courseRevenueData['totalOverallCourseRevenue']!;

          final totalMensalReceitas = donationData['monthlyDonnations']! +
              courseRevenueData['totalMonthlyCourseRevenue']! +
              incomeData['totalOverallSum']!;

          return {
            'totalReceitas': totalReceitas,
            'totalMensalReceitas': totalMensalReceitas,
            'totalBalance': donationData['totalDonations']!,
            'totalOverallSum': incomeData['totalOverallSum']!,
            'totalOverallCourseRevenue':
                courseRevenueData['totalOverallCourseRevenue']!,
            'totalMonthlyCourseRevenue':
                courseRevenueData['totalMonthlyCourseRevenue']!,
          };
        }),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('Receitas não encontradas.'));
          }

          final data = snapshot.data!;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 410,
                    child: AnnualIncomeChart(
                      totalReceita: data['totalReceitas']!,
                      totalDonations: data['totalBalance']!,
                      totalCourseRevenue: data['totalOverallCourseRevenue']!,
                      totallIncome: data['totalOverallSum']!,
                      isDarkMode:
                          Theme.of(context).brightness == Brightness.dark,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Receita Mensal',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(
                    height: 400,
                    child: MonthlyIncomeChart(
                      totalMonthlyReceita: data['totalMensalReceitas']!,
                      totalMonthlyIncome: data['totalOverallSum']!,
                      totalMonthlyCourseRevenue:
                          data['totalMonthlyCourseRevenue']!,
                      totalMonthlyDonations: data['totalBalance']!,
                      isDarkMode:
                          Theme.of(context).brightness == Brightness.dark,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 500,
                    child: OverallIncomeChart(
                      totalOverallReceita: data['totalReceitas']!,
                      totalOverallSum: data['totalOverallSum']!,
                      totalOverallCourseRevenue:
                          data['totalOverallCourseRevenue']!,
                      totalOverallDonations: data['totalBalance']!,
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

class AnnualIncomeChart extends StatelessWidget {
  final double totalReceita;
  final double totallIncome;
  final double totalCourseRevenue;
  final double totalDonations;
  final bool isDarkMode;

  const AnnualIncomeChart({
    super.key,
    required this.totallIncome,
    required this.totalCourseRevenue,
    required this.totalDonations,
    required this.isDarkMode,
    required this.totalReceita,
  });

  double safeValue(double value) => value.isFinite ? value : 0;

  @override
  Widget build(BuildContext context) {
    final safeTotalIncome = safeValue(totallIncome);
    final safeTotalCourseRevenue = safeValue(totalCourseRevenue);
    final safeTotalDonations = safeValue(totalDonations);
    final safeTotalReceita = safeValue(totalReceita);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Receita Total',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 240,
          child: PieChart(
            PieChartData(
              sections: [
                PieChartSectionData(
                  value: safeTotalDonations,
                  color: kDonationColor,
                  radius: 60,
                  titleStyle: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                PieChartSectionData(
                  value: safeTotalCourseRevenue,
                  color: kCourseColor,
                  radius: 60,
                  titleStyle: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                PieChartSectionData(
                  value: safeTotalIncome,
                  color: kIncomeColor,
                  radius: 60,
                  titleStyle: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ],
              borderData: FlBorderData(show: false),
              centerSpaceRadius: 50,
              sectionsSpace: 0,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLegendItem(
                'Doações', safeTotalDonations, kDonationColor, isDarkMode),
            _buildLegendItem(
                'Cursos', safeTotalCourseRevenue, kCourseColor, isDarkMode),
            _buildLegendItem(
                'Outros', safeTotalIncome, kIncomeColor, isDarkMode),
            _buildLegendItem(
                'Total', safeTotalReceita, kTotalColor, isDarkMode),
          ],
        ),
      ],
    );
  }

  Widget _buildLegendItem(
      String title, double value, Color color, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            color: color,
          ),
          const SizedBox(width: 8),
          Text(
            '$title: $value',
            style: TextStyle(
              fontSize: 14,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class MonthlyIncomeChart extends StatelessWidget {
  final double totalMonthlyReceita;
  final double totalMonthlyIncome;
  final double totalMonthlyCourseRevenue;
  final double totalMonthlyDonations;
  final bool isDarkMode;

  const MonthlyIncomeChart({
    super.key,
    required this.totalMonthlyReceita,
    required this.totalMonthlyIncome,
    required this.totalMonthlyCourseRevenue,
    required this.totalMonthlyDonations,
    required this.isDarkMode,
  });

  double safeValue(double value) => value.isFinite ? value : 0;

  @override
  Widget build(BuildContext context) {
    final safeTotalMonthlyIncome = safeValue(totalMonthlyIncome);
    final safeTotalMonthlyCourseRevenue = safeValue(totalMonthlyCourseRevenue);
    final safeTotalMonthlyDonations = safeValue(totalMonthlyDonations);
    final safeTotalMonthlyReceita = safeValue(totalMonthlyReceita);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        SizedBox(
          height: 240,
          child: PieChart(
            PieChartData(
              sections: [
                PieChartSectionData(
                  value: safeTotalMonthlyIncome,
                  color: kIncomeColor,
                  radius: 60,
                  titleStyle: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                PieChartSectionData(
                  value: safeTotalMonthlyCourseRevenue,
                  color: kCourseColor,
                  radius: 60,
                  titleStyle: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                PieChartSectionData(
                  value: safeTotalMonthlyDonations,
                  color: kDonationColor,
                  radius: 60,
                  titleStyle: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ],
              borderData: FlBorderData(show: false),
              centerSpaceRadius: 50,
              sectionsSpace: 0,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLegendItem(
                'Doações ', safeTotalMonthlyIncome, kDonationColor, isDarkMode),
            _buildLegendItem('Cursos ', safeTotalMonthlyCourseRevenue,
                kCourseColor, isDarkMode),
            _buildLegendItem(
                'Outros ', safeTotalMonthlyDonations, kIncomeColor, isDarkMode),
            _buildLegendItem(
                'Total ', safeTotalMonthlyReceita, kTotalColor, isDarkMode),
          ],
        ),
      ],
    );
  }

  Widget _buildLegendItem(
      String title, double value, Color color, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            color: color,
          ),
          const SizedBox(width: 8),
          Text(
            '$title: € ${value.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 14,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class OverallIncomeChart extends StatelessWidget {
  final double totalOverallReceita;
  final double totalOverallSum;
  final double totalOverallCourseRevenue;
  final double totalOverallDonations;
  final bool isDarkMode;

  const OverallIncomeChart({
    super.key,
    required this.totalOverallSum,
    required this.totalOverallCourseRevenue,
    required this.totalOverallDonations,
    required this.isDarkMode,
    required this.totalOverallReceita,
  });

  double safeValue(double value) => value.isFinite ? value : 0;

  @override
  Widget build(BuildContext context) {
    final safeTotalOveralReceita = safeValue(totalOverallReceita);
    final safeTotalOverallSum = safeValue(totalOverallSum);
    final safeTotalOverallCourseRevenue = safeValue(totalOverallCourseRevenue);
    final safeTotalOverallDonations = safeValue(totalOverallDonations);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          'Distribuição de Receitas Totais',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 50),
        SizedBox(
          height: 270,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceEvenly,
              titlesData: const FlTitlesData(show: true),
              borderData: FlBorderData(show: false),
              gridData: const FlGridData(show: false),
              maxY: safeTotalOverallSum,
              barGroups: [
                BarChartGroupData(
                  x: 0,
                  barRods: [
                    BarChartRodData(
                      toY: safeTotalOverallDonations,
                      color: kDonationColor,
                      width: 20,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ],
                ),
                BarChartGroupData(
                  x: 1,
                  barRods: [
                    BarChartRodData(
                      toY: safeTotalOverallCourseRevenue,
                      color: kCourseColor,
                      width: 20,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ],
                ),
                BarChartGroupData(
                  x: 2,
                  barRods: [
                    BarChartRodData(
                      toY: safeTotalOverallSum,
                      color: kCourseColor,
                      width: 20,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLegendItem('Doações ', safeTotalOverallDonations,
                    const Color(0xFF4CAF50), isDarkMode),
                _buildLegendItem('Cursos ', safeTotalOverallCourseRevenue,
                    const Color(0xFF2196F3), isDarkMode),
                _buildLegendItem('Outros ', safeTotalOverallSum,
                    const Color(0xFFFF9800), isDarkMode),
                _buildLegendItem('Total ', safeTotalOveralReceita,
                    const Color(0xFF9C27B0), isDarkMode),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(
      String title, double value, Color color, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            color: color,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '$title: € ${value.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
