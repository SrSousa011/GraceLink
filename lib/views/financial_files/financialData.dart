import 'package:churchapp/data/model/user_data.dart';
import 'package:churchapp/views/donations/donnation_service.dart';
import 'package:churchapp/views/donations/financial/donnation_status.dart';
import 'package:churchapp/views/financial_files/expense/expenses_service.dart';
import 'package:churchapp/views/financial_files/revenue_service.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FinancialData {
  final Map<String, double> revenues;
  final DonationStats donationStats;
  final Map<String, double> annualExpenses;
  final UserData? userData;

  FinancialData({
    required this.revenues,
    required this.donationStats,
    required this.annualExpenses,
    required this.userData,
  });
}

class FinancialService {
  final FirebaseAuth _auth; // Instância do FirebaseAuth
  final FirebaseFirestore _firestore; // Instância do Firestore
  final RevenueService
      _revenueService; // Supondo que você tenha um serviço de receitas
  final ExpensesService
      _expensesService; // Supondo que você tenha um serviço de despesas

  // Construtor para injetar as dependências
  FinancialService({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
    required RevenueService revenueService,
    required ExpensesService expensesService,
  })  : _auth = auth,
        _firestore = firestore,
        _revenueService = revenueService,
        _expensesService = expensesService;

  Future<FinancialData> fetchAllFinancialData() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    try {
      // Fetch revenues
      final revenues = await _revenueService.fetchAllRevenues();

      // Fetch donation stats
      final donationQuerySnapshot = await _firestore
          .collection('donations')
          .where('userId', isEqualTo: user.uid)
          .get();
      final donationStats = DonationStats.fromDonations(
          donationQuerySnapshot.docs.cast<Donation>());

      // Fetch annual expenses
      final now = DateTime.now();
      final startOfYear = DateTime(now.year, 1, 1);
      final endOfYear =
          DateTime(now.year + 1, 1, 1).subtract(const Duration(days: 1));
      final annualExpenses =
          await _expensesService.fetchAnnualExpenses(startOfYear, endOfYear);

      // Fetch user data
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      final userData = UserData.fromDocument(userDoc);

      return FinancialData(
        revenues: revenues,
        donationStats: donationStats,
        annualExpenses: annualExpenses,
        userData: userData,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching all financial data: $e');
      }
      throw Exception('Failed to fetch financial data');
    }
  }
}
