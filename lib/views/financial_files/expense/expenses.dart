import 'package:churchapp/views/financial_files/expense/anual_chart.dart';
import 'package:churchapp/views/financial_files/expense/monthly_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Cores gerais
const Color generalExpensesColor = Colors.red;
const Color expensesColor = Colors.red;
const Color salariesColor = Colors.blue;
const Color maintenanceColor = Colors.orange;
const Color servicesColor = Colors.green;
const Color totalColor = Colors.purple;

// Cores anuais
const Color annualSalariesColor = Colors.red;
const Color annualMaintenanceColor = Colors.green;
const Color annualOtherExpensesColor = Colors.orange;

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  late Future<List<Map<String, double>>> _expensesAndAnnualExpensesFuture;

  @override
  void initState() {
    super.initState();
    _expensesAndAnnualExpensesFuture = Future.wait([
      _fetchExpenses(),
      _fetchAnnualExpenses(),
    ]);
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

  Future<Map<String, double>> _fetchAnnualExpenses() async {
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

    double totalUtilities = 0.0;
    double totalSalaries = 0.0;
    double totalMaintenance = 0.0;
    double totalOtherExpenses = 0.0;

    for (var doc in querySnapshot.docs) {
      final data = doc.data();
      final amount = (data['amount'] as num).toDouble();
      final type = data['type'] as String;

      if (type == 'Utilidades') {
        totalUtilities += amount;
      } else if (type == 'Salários') {
        totalSalaries += amount;
      } else if (type == 'Manutenção') {
        totalMaintenance += amount;
      } else {
        totalOtherExpenses += amount;
      }
    }

    final totalAnnualExpenses =
        totalUtilities + totalSalaries + totalMaintenance + totalOtherExpenses;

    return {
      'totalUtilities': totalUtilities,
      'totalSalaries': totalSalaries,
      'totalMaintenance': totalMaintenance,
      'totalOtherExpenses': totalOtherExpenses,
      'totalAnnualExpenses': totalAnnualExpenses,
    };
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Despesas Mensais e Anuais'),
      ),
      body: FutureBuilder<List<Map<String, double>>>(
        future: _expensesAndAnnualExpensesFuture,
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

          final expenses = snapshot.data![0];
          final annualExpenses = snapshot.data![1];

          // Verificações de nulo e presença das chaves nos mapas
          final totalGeneralExpenses = expenses['totalGeneralExpenses'] ?? 0.0;
          final totalSalaries = expenses['totalSalaries'] ?? 0.0;
          final totalMaintenance = expenses['totalMaintenance'] ?? 0.0;
          final totalServices = expenses['totalServices'] ?? 0.0;
          final totalMonthlyExpenses = expenses['totalMonthlyExpenses'] ?? 0.0;

          final totalAnnualSalaries = annualExpenses['totalSalaries'] ?? 0.0;
          final totalAnnualMaintenance =
              annualExpenses['totalMaintenance'] ?? 0.0;
          final totalOtherExpenses =
              annualExpenses['totalOtherExpenses'] ?? 0.0;
          final totalAnnualExpenses =
              annualExpenses['totalAnnualExpenses'] ?? 0.0;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MonthlyExpensesChart(
                    totalGeneralExpenses: totalGeneralExpenses,
                    totalSalaries: totalSalaries,
                    totalMaintenance: totalMaintenance,
                    totalServices: totalServices,
                    totalMonthlyExpenses: totalMonthlyExpenses,
                    isDarkMode: isDarkMode,
                  ),
                  const SizedBox(height: 40),
                  AnnualExpenseChart(
                    totalGeneralExpenses: totalGeneralExpenses,
                    totalSalaries: totalAnnualSalaries,
                    totalMaintenance: totalAnnualMaintenance,
                    totalServices: totalOtherExpenses,
                    totalAnnualExpenses: totalAnnualExpenses,
                    isDarkMode: isDarkMode,
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
