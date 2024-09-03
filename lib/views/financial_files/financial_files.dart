import 'package:churchapp/views/financial_files/expenses.dart';
import 'package:churchapp/views/financial_files/graphics_screen.dart';
import 'package:churchapp/views/financial_files/incomes.dart';
import 'package:churchapp/views/financial_files/other.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FinanceScreen extends StatefulWidget {
  const FinanceScreen({super.key});

  @override
  State<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Future<Map<String, dynamic>> _userData;

  @override
  void initState() {
    super.initState();
    _userData = _fetchUserData();
  }

  Future<Map<String, dynamic>> _fetchUserData() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (doc.exists) {
      return doc.data() as Map<String, dynamic>;
    } else {
      throw Exception('User data not found');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final primaryTextColor = isDarkMode ? Colors.white : Colors.black;
    final cardBackgroundColor = isDarkMode ? Colors.grey[800]! : Colors.blue;
    final cardBackOutgroundColor = isDarkMode
        ? Colors.grey[800]!
        : const Color.fromARGB(255, 239, 241, 242);
    final cardTextColor = isDarkMode ? Colors.white : Colors.black;
    final accentColor = isDarkMode ? Colors.blueGrey : Colors.blue;
    final incomeColor =
        isDarkMode ? Colors.lightGreenAccent : Colors.lightGreen;
    final expenseColor = isDarkMode ? Colors.redAccent : Colors.red;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: FutureBuilder<Map<String, dynamic>>(
        future: _userData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('User data not found.'));
          }

          final data = snapshot.data!;
          final userName = data['fullName'] ?? 'User';
          final totalBalance = data['totalBalance'] ?? 0.0;
          final totalIncome = data['totalIncome'] ?? 0.0;
          final totalExpenses = data['totalExpenses'] ?? 0.0;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.45,
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(60),
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 60.0, left: 16.0, right: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bom Dia',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                        ),
                      ),
                      const SizedBox(height: 4), // Menor espaço
                      Text(
                        userName,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Cartão de Saldo Total
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const GraphicsScreen(),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: 80.0,
                          decoration: BoxDecoration(
                            color: cardBackgroundColor,
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.account_balance,
                                  size: 24, color: primaryTextColor),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Saldo Total',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: primaryTextColor,
                                      ),
                                    ),
                                    Text(
                                      '€ ${totalBalance.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: primaryTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                      // Cartões de Receitas e Despesas
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ReceitasScreen(),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                height: 80.0,
                                decoration: BoxDecoration(
                                  color: cardBackgroundColor,
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.trending_up,
                                        size: 24, color: incomeColor),
                                    const SizedBox(width: 8),
                                    Text(
                                      '€ ${totalIncome.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: 25,
                                        color: incomeColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ExpensesScreen(),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                height: 80.0,
                                decoration: BoxDecoration(
                                  color: cardBackgroundColor,
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.trending_down,
                                        size: 24, color: expenseColor),
                                    const SizedBox(width: 8),
                                    Text(
                                      '€ ${totalExpenses.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: 25,
                                        color: expenseColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Manter configurações originais para Próximos Lançamentos e Histórico de Transações
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProximosLancamentosScreen(),
                    ),
                  );
                },
                child: _buildFinanceSectionCard(
                  icon: Icons.event_note,
                  title: 'Próximos Lançamentos',
                  value: '',
                  backgroundColor: cardBackOutgroundColor,
                  titleColor: cardTextColor,
                  valueColor: cardTextColor,
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HistoricoTransacoesScreen(),
                    ),
                  );
                },
                child: _buildFinanceSectionCard(
                  icon: Icons.history,
                  title: 'Histórico de Transações',
                  value: '',
                  backgroundColor: cardBackOutgroundColor,
                  titleColor: cardTextColor,
                  valueColor: cardTextColor,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFinanceSectionCard({
    required IconData icon,
    required String title,
    required String value,
    required Color backgroundColor,
    required Color titleColor,
    required Color valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: titleColor,
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    color: valueColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
