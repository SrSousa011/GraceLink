import 'package:churchapp/views/financial_files/expense/expense_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExpensesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<ExpenseData> fetchData(
      DateTime startOfYear, DateTime endOfYear) async {
    final annualData = await fetchAnnualExpenses(startOfYear, endOfYear);
    final monthlyData = await fetchMonthlyExpenses(startOfYear, endOfYear);

    double annualGeneralExpenses = annualData['totalGeneralExpenses'] ?? 0.0;
    double annualSalaries = annualData['totalSalaries'] ?? 0.0;
    double annualMaintenance = annualData['totalMaintenance'] ?? 0.0;
    double annualServices = annualData['totalServices'] ?? 0.0;

    double totalAnnualExpenses = annualGeneralExpenses +
        annualSalaries +
        annualMaintenance +
        annualServices;

    return ExpenseData(
      totalExpenses: totalAnnualExpenses,
      expensesPerMonth: monthlyData,
    );
  }

  Future<Map<String, double>> fetchAnnualExpenses(
      DateTime startOfYear, DateTime endOfYear) async {
    try {
      final querySnapshot = await _firestore
          .collection('transactions')
          .where('type', isEqualTo: 'Despesa')
          .where('transactionDate', isGreaterThanOrEqualTo: startOfYear)
          .where('transactionDate', isLessThan: endOfYear)
          .get();

      double annualGeneralExpenses = 0.0;
      double annualSalaries = 0.0;
      double annualMaintenance = 0.0;
      double annualServices = 0.0;
      double totalAnnualExpenses = 0.0;

      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        final amount = (data['amount'] as num?)?.toDouble() ?? 0.0;
        final category = data['category'] as String? ?? 'Desconhecido';

        switch (category) {
          case 'Despesas Gerais':
            annualGeneralExpenses += amount;
            break;
          case 'Salários':
            annualSalaries += amount;
            break;
          case 'Manutenção':
            annualMaintenance += amount;
            break;
          case 'Serviços':
            annualServices += amount;
            break;
          default:
            break;
        }
      }
      return {
        'totalGeneralExpenses': annualGeneralExpenses,
        'totalSalaries': annualSalaries,
        'totalMaintenance': annualMaintenance,
        'totalServices': annualServices,
        'totalAnnualExpenses': totalAnnualExpenses,
      };
    } catch (e) {
      throw Exception('Error fetching annual expenses: $e');
    }
  }

  Future<Map<String, double>> fetchMonthlyExpenses(
      DateTime startOfMonth, DateTime endOfMonth) async {
    try {
      final querySnapshot = await _firestore
          .collection('transactions')
          .where('type', isEqualTo: 'Despesa')
          .where('transactionDate', isGreaterThanOrEqualTo: startOfMonth)
          .where('transactionDate', isLessThan: endOfMonth)
          .get();

      double monthlyGeneralExpenses = 0.0;
      double monthlySalaries = 0.0;
      double monthlyMaintenance = 0.0;
      double monthlyServices = 0.0;

      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        final amount = (data['amount'] as num?)?.toDouble() ?? 0.0;
        final category = data['category'] as String? ?? 'Desconhecido';

        switch (category) {
          case 'Despesas Gerais':
            monthlyGeneralExpenses += amount;
            break;
          case 'Salários':
            monthlySalaries += amount;
            break;
          case 'Manutenção':
            monthlyMaintenance += amount;
            break;
          case 'Serviços':
            monthlyServices += amount;
            break;
          default:
            break;
        }
      }

      return {
        'totalGeneralExpenses': monthlyGeneralExpenses,
        'totalSalaries': monthlySalaries,
        'totalMaintenance': monthlyMaintenance,
        'totalServices': monthlyServices,
        'totalMonthlyExpenses': monthlyGeneralExpenses +
            monthlySalaries +
            monthlyMaintenance +
            monthlyServices,
      };
    } catch (e) {
      throw Exception('Error fetching monthly expenses: $e');
    }
  }
}
