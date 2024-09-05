import 'package:churchapp/views/courses/service/courses_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:churchapp/views/donations/financial/donnation_status.dart';
import 'package:churchapp/views/financial_files/income/add_income.dart';

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
      throw e;
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

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                const SectionTitle(title: 'Receitas'),
                InfoCard(
                  title: 'Total de Doações',
                  value: '€ ${data['totalBalance']!.toStringAsFixed(2)}',
                  color: Colors.grey[100],
                ),
                const SizedBox(height: 20),
                InfoCard(
                  title: 'Doações Mensais',
                  value: '€ ${data['monthlyIncome']!.toStringAsFixed(2)}',
                  color: Colors.grey[100],
                ),
                const SizedBox(height: 20),
                InfoCard(
                  title: 'Total Geral Incomes',
                  value: '€ ${data['totalOverallSum']!.toStringAsFixed(2)}',
                  color: Colors.grey[100],
                ),
                const SizedBox(height: 20),
                InfoCard(
                  title: 'Total Mensal Incomes',
                  value: '€ ${data['totalMonthlySum']!.toStringAsFixed(2)}',
                  color: Colors.grey[100],
                ),
                const SizedBox(height: 20),
                InfoCard(
                  title: 'Total Cursos',
                  value:
                      '€ ${data['totalOverallCourseRevenue']!.toStringAsFixed(2)}',
                  color: Colors.grey[100],
                ),
                const SizedBox(height: 20),
                InfoCard(
                  title: 'Total Mensal Cursos',
                  value:
                      '€ ${data['totalMonthlyCourseRevenue']!.toStringAsFixed(2)}',
                  color: Colors.grey[100],
                ),
                const SizedBox(height: 20),
                InfoCard(
                  title: 'Total Receitas',
                  value: '€ ${data['totalReceitas']!.toStringAsFixed(2)}',
                  color: Colors.green[100],
                ),
                const SizedBox(height: 20),
                InfoCard(
                  title: 'Total Mensal Receitas',
                  value: '€ ${data['totalMensalReceitas']!.toStringAsFixed(2)}',
                  color: Colors.green[100],
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddIncomeForm(),
            ),
          );
        },
        backgroundColor: const Color(0xFF4CAF50),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
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
        title: Text(title),
        trailing: Text(value, style: Theme.of(context).textTheme.titleLarge),
      ),
    );
  }
}
