import 'package:churchapp/views/courses/service/courses_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:churchapp/views/donations/financial/donnation_status.dart';
import 'package:fl_chart/fl_chart.dart';

class IncomesScreen extends StatelessWidget {
  final DonationStats donationStats;
  final CoursesService _coursesService = CoursesService();

  IncomesScreen({super.key, required this.donationStats});

  Future<Map<String, double>> _fetchIncomeData() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('User not authenticated');
    }

    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 1);

    final querySnapshot = await firestore
        .collection('transactions')
        .where('createdBy', isEqualTo: user.uid)
        .where('category', isEqualTo: 'income')
        .get();

    double totalOverallSum = 0;
    double totalMonthlySum = 0;

    for (final doc in querySnapshot.docs) {
      final data = doc.data();
      final amount = (data['amount'] as num).toDouble();
      final createdAt = (data['createdAt'] as Timestamp).toDate();

      totalOverallSum += amount;

      if (createdAt.isAfter(startOfMonth) && createdAt.isBefore(endOfMonth)) {
        totalMonthlySum += amount;
      }
    }

    return {
      'totalOverallSum': totalOverallSum,
      'totalMonthlySum': totalMonthlySum,
    };
  }

  Future<Map<String, double>> _fetchCourseRevenueData() async {
    try {
      final totalRevenue = await _coursesService.calculateTotalRevenue();
      final monthlyRevenue = await _coursesService.calculateMonthlyRevenue();

      return {
        'totalOverallRevenue': totalRevenue,
        'totalMonthlyRevenue': monthlyRevenue,
      };
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching course revenue data: $e');
      }
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receitas'),
        backgroundColor: Colors.green[700],
      ),
      body: FutureBuilder<Map<String, double>>(
        future: Future.wait([
          _fetchIncomeData(),
          _fetchCourseRevenueData(),
          Future.value({
            'totalBalance': donationStats.totalBalance,
            'monthlyIncome': donationStats.monthlyIncome,
          }),
        ]).then((results) {
          final incomeData = results[0];
          final courseRevenueData = results[1];
          final donationData = results[2];

          final totalReceitas = donationData['totalBalance']! +
              incomeData['totalOverallSum']! +
              courseRevenueData['totalOverallRevenue']!;
          final totalMensalReceitas = donationData['monthlyIncome']! +
              incomeData['totalMonthlySum']! +
              courseRevenueData['totalMonthlyRevenue']!;

          return {
            'totalReceitas': totalReceitas,
            'totalMensalReceitas': totalMensalReceitas,
            'totalBalance': donationData['totalBalance']!,
            'monthlyIncome': donationData['monthlyIncome']!,
            'totalOverallSum': incomeData['totalOverallSum']!,
            'totalMonthlySum': incomeData['totalMonthlySum']!,
            'totalOverallCourseRevenue':
                courseRevenueData['totalOverallRevenue']!,
            'totalMonthlyCourseRevenue':
                courseRevenueData['totalMonthlyRevenue']!,
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
                children: [
                  SizedBox(
                    height: 300,
                    child: MonthlyIncomeChart(
                      totalMonthlyIncome: data['totalMonthlySum']!,
                      totalMonthlyCourseRevenue:
                          data['totalMonthlyCourseRevenue']!,
                      totalMonthlyDonations: data['monthlyIncome']!,
                      isDarkMode:
                          Theme.of(context).brightness == Brightness.dark,
                    ),
                  ),
                  const SizedBox(height: 16), // Space between charts
                  SizedBox(
                    height: 300,
                    child: OverallIncomeChart(
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

class InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final Color? color;

  const InfoCard({
    super.key,
    required this.title,
    required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: ListTile(
        title: Text(title, style: Theme.of(context).textTheme.bodyLarge),
        trailing: Text(value, style: Theme.of(context).textTheme.titleLarge),
      ),
    );
  }
}

class MonthlyIncomeChart extends StatelessWidget {
  final double totalMonthlyIncome;
  final double totalMonthlyCourseRevenue;
  final double totalMonthlyDonations;
  final bool isDarkMode;

  const MonthlyIncomeChart({
    super.key,
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 300,
          child: PieChart(
            PieChartData(
              sections: [
                PieChartSectionData(
                  value: safeTotalMonthlyIncome,
                  title:
                      'Doações Mensais\n€ ${safeTotalMonthlyIncome.toStringAsFixed(2)}',
                  color: Colors.blue,
                  radius: 100,
                  titleStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                PieChartSectionData(
                  value: safeTotalMonthlyCourseRevenue,
                  title:
                      'Cursos Mensais\n€ ${safeTotalMonthlyCourseRevenue.toStringAsFixed(2)}',
                  color: Colors.orange,
                  radius: 100,
                  titleStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                PieChartSectionData(
                  value: safeTotalMonthlyDonations,
                  title:
                      'Total Income\n€ ${safeTotalMonthlyDonations.toStringAsFixed(2)}',
                  color: Colors.green,
                  radius: 100,
                  titleStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ],
              borderData: FlBorderData(show: false),
              centerSpaceRadius: 40,
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildLegendItem(
            'Doações Mensais', safeTotalMonthlyIncome, Colors.blue, isDarkMode),
        _buildLegendItem('Cursos Mensais', safeTotalMonthlyCourseRevenue,
            Colors.orange, isDarkMode),
        _buildLegendItem('Total Mensal', safeTotalMonthlyDonations,
            Colors.green, isDarkMode),
      ],
    );
  }

  Widget _buildLegendItem(
      String title, double value, Color color, bool isDarkMode) {
    return Row(
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
    );
  }
}

class OverallIncomeChart extends StatelessWidget {
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
  });

  double safeValue(double value) => value.isFinite ? value : 0;

  @override
  Widget build(BuildContext context) {
    final safeTotalOverallSum = safeValue(totalOverallSum);
    final safeTotalOverallCourseRevenue = safeValue(totalOverallCourseRevenue);
    final safeTotalOverallDonations = safeValue(totalOverallDonations);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 300,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceEvenly,
              titlesData: FlTitlesData(show: true),
              borderData: FlBorderData(show: false),
              gridData: FlGridData(show: false),
              maxY: safeTotalOverallSum,
              barGroups: [
                BarChartGroupData(
                  x: 0,
                  barRods: [
                    BarChartRodData(
                      toY: safeTotalOverallDonations,
                      color: Colors.green,
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
                      color: Colors.orange,
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
                      color: Colors.blue,
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
        _buildLegendItem('Doações Totais', safeTotalOverallDonations,
            Colors.green, isDarkMode),
        _buildLegendItem('Cursos Totais', safeTotalOverallCourseRevenue,
            Colors.orange, isDarkMode),
        _buildLegendItem(
            'Total Geral', safeTotalOverallSum, Colors.blue, isDarkMode),
      ],
    );
  }

  Widget _buildLegendItem(
      String title, double value, Color color, bool isDarkMode) {
    return Row(
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
    );
  }
}
