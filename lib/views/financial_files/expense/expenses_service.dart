import 'package:churchapp/views/financial_files/expense/expense_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExpensesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<ExpenseData> fetchData(
      DateTime startOfYear, DateTime endOfYear) async {
    final annualData = await fetchAnnualExpenses(startOfYear, endOfYear);
    final monthlyData = await fetchMonthlyExpenses(startOfYear, endOfYear);

    return ExpenseData(
      totalExpenses: annualData['totalAnnualExpenses'] ?? 0.0,
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

      List<double> monthlyGeneralExpenses = List.filled(12, 0.0);
      List<double> monthlySalaries = List.filled(12, 0.0);
      List<double> monthlyMaintenance = List.filled(12, 0.0);
      List<double> monthlyServices = List.filled(12, 0.0);

      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        final amount = (data['amount'] as num?)?.toDouble() ?? 0.0;
        final category = data['category'] as String? ?? 'Desconhecido';
        final timestamp = (data['transactionDate'] as Timestamp).toDate();
        final month = timestamp.month - 1;

        switch (category) {
          case 'Despesas Gerais':
            annualGeneralExpenses += amount;
            monthlyGeneralExpenses[month] += amount;
            break;
          case 'Salários':
            annualSalaries += amount;
            monthlySalaries[month] += amount;
            break;
          case 'Manutenção':
            annualMaintenance += amount;
            monthlyMaintenance[month] += amount;
            break;
          case 'Serviços':
            annualServices += amount;
            monthlyServices[month] += amount;
            break;
          default:
            break;
        }
      }

      final totalAnnualExpenses = annualGeneralExpenses +
          annualSalaries +
          annualMaintenance +
          annualServices;

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

  Future<double> fetchAllExpenses() async {
    return await _getTotalFromCollection('transactions', 'Despesa', 'amount');
  }

  Future<double> _getTotalFromCollection(
      String collection, String? type, String field) async {
    try {
      final query = _firestore.collection(collection);
      final snapshot = type != null
          ? await query.where('type', isEqualTo: type).get()
          : await query.get();

      return snapshot.docs.fold<double>(0.0, (total, doc) {
        double value =
            (doc[field] ?? 0.0) is num ? (doc[field] as num).toDouble() : 0.0;
        return total + value;
      });
    } catch (e) {
      throw Exception('Error fetching total from collection $collection: $e');
    }
  }

  Future<Map<String, double>> fetchMonthlyExpenses(
      DateTime startOfMonth, DateTime endOfMonth) async {
    try {
      final querySnapshot = await _firestore
          .collection('transactions')
          .where('type', isEqualTo: 'Despesa')
          .where('transactionDate', isGreaterThanOrEqualTo: startOfMonth)
          .where('transactionDate', isLessThanOrEqualTo: endOfMonth)
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

      final totalMonthlyExpenses = monthlyGeneralExpenses +
          monthlySalaries +
          monthlyMaintenance +
          monthlyServices;

      return {
        'totalGeneralExpenses': monthlyGeneralExpenses,
        'totalSalaries': monthlySalaries,
        'totalMaintenance': monthlyMaintenance,
        'totalServices': monthlyServices,
        'totalMonthlyExpenses': totalMonthlyExpenses,
      };
    } catch (e) {
      throw Exception('Error fetching monthly expenses: $e');
    }
  }
}
