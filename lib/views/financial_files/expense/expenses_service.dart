import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ExpensesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Map<String, double>> fetchExpenses(
      DateTime startOfMonth, DateTime endOfMonth) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('Usuário não autenticado');
    }

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
      final amount = (data['amount'] as num).toDouble();
      final type = data['category'] as String;

      if (type == 'Despesas Gerais') {
        monthlyGeneralExpenses += amount;
      } else if (type == 'Salários') {
        monthlySalaries += amount;
      } else if (type == 'Manutenção') {
        monthlyMaintenance += amount;
      } else if (type == 'Serviços') {
        monthlyServices += amount;
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
  }

  Future<Map<String, double>> fetchAnnualExpenses(
      DateTime startOfYear, DateTime endOfYear) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('Usuário não autenticado');
    }

    final querySnapshot = await _firestore
        .collection('transactions')
        .where('createdBy', isEqualTo: user.uid)
        .where('type', isEqualTo: 'Despesa')
        .where('createdAt', isGreaterThanOrEqualTo: startOfYear)
        .where('createdAt', isLessThanOrEqualTo: endOfYear)
        .get();

    double annualGeneralExpenses = 0.0;
    double annualSalaries = 0.0;
    double annualMaintenance = 0.0;
    double annualServices = 0.0;

    for (var doc in querySnapshot.docs) {
      final data = doc.data();
      final amount = (data['amount'] as num).toDouble();
      final type = data['category'] as String;

      if (type == 'Despesas Gerais') {
        annualGeneralExpenses += amount;
      } else if (type == 'Salários') {
        annualSalaries += amount;
      } else if (type == 'Manutenção') {
        annualMaintenance += amount;
      } else if (type == 'Serviços') {
        annualServices += amount;
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
  }
}
