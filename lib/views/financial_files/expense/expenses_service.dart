import 'package:churchapp/views/financial_files/expense/expende_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ExpensesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Fetches annual expenses based on the specified date range and user.
  Future<Map<String, double>> fetchAnnualExpenses(
      DateTime startOfYear, DateTime endOfYear) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('Usuário não autenticado');
    }

    try {
      final querySnapshot = await _firestore
          .collection('transactions')
          .where('createdBy', isEqualTo: user.uid)
          .where('type', isEqualTo: 'Despesa')
          .where('createdAt', isGreaterThanOrEqualTo: startOfYear)
          .where('createdAt',
              isLessThan: endOfYear) // Exclude the last day of the year
          .get();

      double annualGeneralExpenses = 0.0;
      double annualSalaries = 0.0;
      double annualMaintenance = 0.0;
      double annualServices = 0.0;

      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        final amount = (data['amount'] as num?)?.toDouble() ?? 0.0;
        final category = data['category'] as String? ?? 'Desconhecido';

        // Categorize expenses
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
      throw Exception('Erro ao buscar despesas: $e');
    }
  }

  /// Fetches all expenses for the authenticated user within the specified date range.
  Future<List<ExpenseData>> fetchAllExpenses(
      DateTime startDate, DateTime endDate) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('Usuário não autenticado');
    }

    try {
      final querySnapshot = await _firestore
          .collection('transactions')
          .where('createdBy', isEqualTo: user.uid)
          .where('type', isEqualTo: 'Despesa')
          .where('createdAt', isGreaterThanOrEqualTo: startDate)
          .where('createdAt',
              isLessThanOrEqualTo: endDate) // Include the last day
          .get();

      // Convert QuerySnapshot to a List of ExpenseData
      return querySnapshot.docs.map((doc) {
        final data = doc.data(); // Cast to Map<String, dynamic>
        final id = doc.id; // Get the document ID
        return ExpenseData.fromFirestore(data, id); // Pass the data map and ID
      }).toList();
    } catch (e) {
      throw Exception('Erro ao buscar todas as despesas: $e');
    }
  }

  Future<Map<String, double>> fetchMonthlyExpenses(
      DateTime startOfMonth, DateTime endOfMonth) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('Usuário não autenticado');
    }

    try {
      final querySnapshot = await _firestore
          .collection('transactions')
          .where('createdBy', isEqualTo: user.uid)
          .where('type', isEqualTo: 'Despesa')
          .where('createdAt', isGreaterThanOrEqualTo: startOfMonth)
          .where('createdAt', isLessThanOrEqualTo: endOfMonth)
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
      throw Exception('Erro ao buscar despesas mensais: $e');
    }
  }
}
