import 'package:churchapp/views/financial/transaction_detail.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:churchapp/views/financial/transaction_page.dart';

class FinancialScreen extends StatefulWidget {
  const FinancialScreen({super.key});

  @override
  State<FinancialScreen> createState() => _FinancialScreenState();
}

class _FinancialScreenState extends State<FinancialScreen> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(child: Text('Usuário não está autenticado.'));
    }

    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(
                child: Text('Dados do usuário não encontrados'));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          final userName = data['fullName'] ?? 'Usuário';
          final totalBalance =
              (data['totalBalance'] as num?)?.toDouble() ?? 1250.75;
          final income = (data['income'] as num?)?.toDouble() ?? 3000.00;
          final expenses = (data['expenses'] as num?)?.toDouble() ?? 1750.00;

          return Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.3,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(80),
                  ),
                ),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 60.0, left: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Bom Dia',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          userName,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                transform: Matrix4.translationValues(0.0, -60.0, 0.0),
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(30),
                          bottom: Radius.circular(30),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildFinancialCard(
                            icon: Icons.account_balance_wallet,
                            title: 'Saldo Total',
                            value: '€ ${totalBalance.toStringAsFixed(2)}',
                            valueStyle: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                            withShadow: false,
                            backgroundColor: Colors.transparent,
                            titleStyle: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: _buildFinancialCard(
                                  icon: Icons.trending_up,
                                  title: 'Receitas',
                                  value: '€ ${income.toStringAsFixed(2)}',
                                  valueStyle: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                  withShadow: false,
                                  backgroundColor: const Color.fromARGB(
                                    0,
                                    98,
                                    162,
                                    241,
                                  ),
                                  titleStyle: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: _buildFinancialCard(
                                  icon: Icons.trending_down,
                                  title: 'Despesas',
                                  value: '€ ${expenses.toStringAsFixed(2)}',
                                  valueStyle: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                  withShadow: false,
                                  backgroundColor: Colors.transparent,
                                  titleStyle: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                  iconColor: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    const transactionItemHeight = 70.0;
                    final availableHeight = constraints.maxHeight;
                    final itemCount =
                        (availableHeight / transactionItemHeight).floor();

                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(30),
                                bottom: Radius.circular(0),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.account_balance,
                                    size: 30, color: Colors.blue),
                                const SizedBox(width: 8),
                                const Text(
                                  'Histórico de Transação',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TransactionsPage(
                                          transactions: transactionData,
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Ver Todos',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount:
                                  itemCount.clamp(0, transactionData.length),
                              itemBuilder: (context, index) {
                                final transaction = transactionData[index];
                                return ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 4.0, horizontal: 0.0),
                                  leading: Icon(
                                    transaction.isPositive
                                        ? Icons.arrow_upward
                                        : Icons.arrow_downward,
                                    color: transaction.isPositive
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                  title: Text(transaction.title),
                                  subtitle: Text(
                                    transaction.isPositive
                                        ? 'Recebido de: ${transaction.from}'
                                        : 'Pago para: ${transaction.from}',
                                  ),
                                  trailing: Text(
                                    '${transaction.isPositive ? '+' : '-'} ${transaction.amount.toStringAsFixed(2)} €',
                                    style: TextStyle(
                                      color: transaction.isPositive
                                          ? Colors.green
                                          : Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            TransactionDetails(
                                          transaction: transaction,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFinancialCard({
    required IconData icon,
    required String title,
    required String value,
    TextStyle? valueStyle,
    bool withShadow = true,
    Color backgroundColor = Colors.white,
    required TextStyle titleStyle,
    Color iconColor = Colors.teal,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: withShadow
            ? [
                const BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ]
            : [],
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: titleStyle,
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: valueStyle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
