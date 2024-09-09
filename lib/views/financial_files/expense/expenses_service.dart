import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ExpenseService {
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
        .where('category', isEqualTo: 'expense')
        .where('date', isGreaterThanOrEqualTo: startOfMonth)
        .where('date', isLessThanOrEqualTo: endOfMonth)
        .get();

    print('Número de documentos retornados: ${querySnapshot.docs.length}');

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

    // Prints para depuração
    print('Despesas Mensais:');
    print('- Despesas Gerais: R\$${totalGeneralExpenses.toStringAsFixed(2)}');
    print('- Salários: R\$${totalSalaries.toStringAsFixed(2)}');
    print('- Manutenção: R\$${totalMaintenance.toStringAsFixed(2)}');
    print('- Serviços: R\$${totalServices.toStringAsFixed(2)}');
    print('- Total Mensal: R\$${totalMonthlyExpenses.toStringAsFixed(2)}');

    return {
      'totalGeneralExpenses': totalGeneralExpenses,
      'totalSalaries': totalSalaries,
      'totalMaintenance': totalMaintenance,
      'totalServices': totalServices,
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
        .where('category', isEqualTo: 'expense')
        .where('date', isGreaterThanOrEqualTo: startOfYear)
        .where('date', isLessThanOrEqualTo: endOfYear)
        .get();

    print('Número de documentos retornados: ${querySnapshot.docs.length}');

    double totalSalaries = 0.0;
    double totalMaintenance = 0.0;
    double totalOtherExpenses = 0.0;

    for (var doc in querySnapshot.docs) {
      final data = doc.data();
      final amount = (data['amount'] as num).toDouble();
      final type = data['type'] as String;

      if (type == 'Salários') {
        totalSalaries += amount;
      } else if (type == 'Manutenção') {
        totalMaintenance += amount;
      } else {
        totalOtherExpenses += amount;
      }
    }

    final totalAnnualExpenses =
        totalSalaries + totalMaintenance + totalOtherExpenses;

    // Prints para depuração
    print('Despesas Anuais:');
    print('- Salários: R\$${totalSalaries.toStringAsFixed(2)}');
    print('- Manutenção: R\$${totalMaintenance.toStringAsFixed(2)}');
    print('- Outras Despesas: R\$${totalOtherExpenses.toStringAsFixed(2)}');
    print('- Total Anual: R\$${totalAnnualExpenses.toStringAsFixed(2)}');

    return {
      'totalSalaries': totalSalaries,
      'totalMaintenance': totalMaintenance,
      'totalOtherExpenses': totalOtherExpenses,
      'totalAnnualExpenses': totalAnnualExpenses,
    };
  }
}
