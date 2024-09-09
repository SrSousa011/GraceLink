import 'package:churchapp/views/financial_files/expense/monthly_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ExpensesScreen extends StatefulWidget {
  @override
  _ExpensesScreenState createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  late Future<Map<String, double>> _expensesFuture;

  // Definindo cores
  final Color _generalExpensesColor = Colors.red;
  final Color _salariesColor = Colors.blue;
  final Color _maintenanceColor = Colors.orange;
  final Color _servicesColor = Colors.green;
  final Color _totalColor = Colors.purple;

  @override
  void initState() {
    super.initState();
    _expensesFuture = _fetchExpenses();
  }

  Future<Map<String, double>> _fetchExpenses() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('Usuário não autenticado');
    }

    final querySnapshot = await firestore
        .collection('transactions')
        .where('createdBy', isEqualTo: user.uid)
        .where('category', isEqualTo: 'expense')
        .get();

    double totalGeneralExpenses = 0.0;
    double totalSalaries = 0.0;
    double totalMaintenance = 0.0;
    double totalServices = 0.0;

    for (var doc in querySnapshot.docs) {
      final data = doc.data();
      final amount = (data['amount'] as num).toDouble();
      final type = data['type'] as String;

      if (type == 'Despesas Gerais') {
        totalGeneralExpenses += amount;
      } else if (type == 'Salários') {
        totalSalaries += amount;
      } else if (type == 'Manutenção') {
        totalMaintenance += amount;
      } else if (type == 'Serviços') {
        totalServices += amount;
      }
    }

    final totalMonthlyExpenses =
        totalGeneralExpenses + totalSalaries + totalMaintenance + totalServices;

    return {
      'totalGeneralExpenses': totalGeneralExpenses,
      'totalSalaries': totalSalaries,
      'totalMaintenance': totalMaintenance,
      'totalServices': totalServices,
      'totalMonthlyExpenses': totalMonthlyExpenses,
    };
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Despesas Mensais'),
      ),
      body: FutureBuilder<Map<String, double>>(
        future: _expensesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('Nenhuma despesa encontrada.'));
          }

          final expenses = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: MonthlyExpensesChart(
              totalGeneralExpenses: expenses['totalGeneralExpenses']!,
              totalSalaries: expenses['totalSalaries']!,
              totalMaintenance: expenses['totalMaintenance']!,
              totalServices: expenses['totalServices']!,
              totalMonthlyExpenses: expenses['totalMonthlyExpenses']!,
              isDarkMode: isDarkMode,
              generalExpensesColor: _generalExpensesColor,
              salariesColor: _salariesColor,
              maintenanceColor: _maintenanceColor,
              servicesColor: _servicesColor,
              totalColor: _totalColor,
            ),
          );
        },
      ),
    );
  }
}
