import 'package:churchapp/views/financial_files/upcomingEvents/add_transaction.dart';
import 'package:churchapp/views/financial_files/upcomingEvents/transaction_details.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UpcomingEventsScreen extends StatelessWidget {
  const UpcomingEventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final secondaryTextColor =
        isDarkMode ? Colors.grey[400]! : Colors.grey[700];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Próximos Lançamentos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Adicione lógica para filtros
            },
          ),
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              // Adicione lógica para ordenação
            },
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _fetchTransactions(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('Nenhuma transação encontrada.'));
                }

                final transactions = snapshot.data!;

                return Expanded(
                  child: ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      final isIncome = transaction['category'] == 'income';
                      final amount = transaction['amount'];
                      final color = isIncome ? Colors.green : Colors.red;

                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        leading: Icon(
                          isIncome ? Icons.arrow_upward : Icons.arrow_downward,
                          color: color,
                        ),
                        title: Text(
                          transaction['source'] ?? '',
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _formatDate(transaction['createdAt']),
                              style: TextStyle(color: secondaryTextColor),
                            ),
                            Text(
                              '${transaction['description']}',
                              style: TextStyle(color: secondaryTextColor),
                            ),
                          ],
                        ),
                        trailing: Text(
                          '€$amount',
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TransactionDetailsScreen(
                              transaction: transaction,
                              color: color,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTransactionForm(),
            ),
          );
        },
        backgroundColor: const Color(0xFF4CAF50),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Future<List<Map<String, dynamic>>> _fetchTransactions() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('Usuário não autenticado');
    }

    final querySnapshot = await firestore
        .collection('transactions')
        .where('createdBy', isEqualTo: user.uid)
        .get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'amount': data['amount'] ?? 'N/A',
        'category': data['category'] ?? 'N/A',
        'createdAt': data['createdAt']?.toDate() ?? DateTime.now(),
        'createdBy': data['createdBy'] ?? 'N/A',
        'date': data['date'] ?? 'N/A',
        'description': data['description'] ?? 'Sem Descrição',
        'reference': data['reference'] ?? 'N/A',
        'source': data['source'] ?? 'N/A',
        'time': data['time'] ?? 'N/A',
        'type': data['type'] ?? 'N/A',
      };
    }).toList();
  }

  String _formatDate(dynamic date) {
    if (date == null) return 'N/A';
    DateTime dt;
    if (date is Timestamp) {
      dt = date.toDate();
    } else if (date is DateTime) {
      dt = date;
    } else {
      return 'N/A';
    }
    final day = dt.day.toString().padLeft(2, '0');
    final month = dt.month.toString().padLeft(2, '0');
    final year = dt.year;
    return '$day/$month/$year';
  }
}
