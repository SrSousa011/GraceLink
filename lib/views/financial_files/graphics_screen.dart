import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GraphicsScreen extends StatelessWidget {
  const GraphicsScreen({super.key});

  Future<Map<String, double>> _fetchFinancialData() async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('User not authenticated');
    }

    final incomeSnapshot = await _firestore
        .collection('transactions')
        .where('userId', isEqualTo: user.uid)
        .where('type', isEqualTo: 'income')
        .get();

    final expenseSnapshot = await _firestore
        .collection('transactions')
        .where('userId', isEqualTo: user.uid)
        .where('type', isEqualTo: 'expense')
        .get();

    double totalIncome = 0.0;
    double totalExpenses = 0.0;

    for (var doc in incomeSnapshot.docs) {
      final data = doc.data();
      final amount = (data['amount'] as num?)?.toDouble() ?? 0.0;
      totalIncome += amount;
    }

    for (var doc in expenseSnapshot.docs) {
      final data = doc.data();
      final amount = (data['amount'] as num?)?.toDouble() ?? 0.0;
      totalExpenses += amount;
    }

    final totalBalance = totalIncome - totalExpenses;

    return {
      'totalIncome': totalIncome,
      'totalExpenses': totalExpenses,
      'totalBalance': totalBalance,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatórios e Gráficos'),
        backgroundColor: Colors.blue[700],
      ),
      body: FutureBuilder<Map<String, double>>(
        future: _fetchFinancialData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(
                child: Text('Dados financeiros não encontrados.'));
          }

          final data = snapshot.data!;
          final totalIncome = data['totalIncome']!;
          final totalExpenses = data['totalExpenses']!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(
                  height: 200,
                  child: LineChart(
                    LineChartData(
                      lineBarsData: [
                        LineChartBarData(
                          spots: [
                            FlSpot(0, totalIncome),
                            FlSpot(1, totalExpenses),
                            // Adicione mais pontos conforme necessário
                          ],
                          isCurved: true,
                          color: Colors.blue,
                          dotData: const FlDotData(show: false),
                          belowBarData: BarAreaData(show: false),
                        ),
                      ],
                      titlesData: const FlTitlesData(show: true),
                      borderData: FlBorderData(
                        show: true,
                        border: Border.all(
                          color: const Color(0xff37434d),
                          width: 1,
                        ),
                      ),
                      gridData: const FlGridData(show: true),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 200,
                  child: PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(
                          value: totalIncome,
                          color: Colors.blue,
                          title: 'Receitas',
                          radius: 50,
                        ),
                        PieChartSectionData(
                          value: totalExpenses,
                          color: Colors.red,
                          title: 'Despesas',
                          radius: 50,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
