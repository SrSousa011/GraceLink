import 'package:churchapp/views/financial_files/upcomingEvents/add_transaction.dart';
import 'package:churchapp/views/financial_files/upcomingEvents/transaction_details.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UpcomingEventsScreen extends StatefulWidget {
  const UpcomingEventsScreen({super.key});

  @override
  State<UpcomingEventsScreen> createState() => _UpcomingEventsScreenState();
}

class _UpcomingEventsScreenState extends State<UpcomingEventsScreen> {
  String _filter = 'all';
  bool _isAscending = false;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final secondaryTextColor =
        isDarkMode ? Colors.grey[400]! : Colors.grey[700];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Próximos Lançamentos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog();
            },
          ),
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              setState(() {
                _isAscending = !_isAscending;
              });
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
                final sortedTransactions = _sortTransactions(transactions);

                return Expanded(
                  child: ListView.builder(
                    itemCount: sortedTransactions.length,
                    itemBuilder: (context, index) {
                      final transaction = sortedTransactions[index];
                      final isIncome = transaction['type'] == 'Rendimento';
                      final amount = transaction['amount'].toString();
                      final color = isIncome ? Colors.green : Colors.red;
                      final icon =
                          isIncome ? Icons.arrow_upward : Icons.arrow_downward;

                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        leading: Icon(
                          icon,
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
                              _formatDate(transaction['transactionDate']),
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
        'transactionId': doc.id,
        'amount': (data['amount'] as num?)?.toString() ?? 'N/A',
        'category': data['category'] ?? 'N/A',
        'transactionDate': data['transactionDate']?.toDate(),
        'description': data['description'] ?? 'Sem Descrição',
        'source': data['source'] ?? 'N/A',
        'type': data['type'] ?? 'N/A',
        'filePath': data['filePath'] ?? 'N/A',
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

  List<Map<String, dynamic>> _sortTransactions(
      List<Map<String, dynamic>> transactions) {
    if (_filter == 'all') {
      transactions.sort((a, b) => _isAscending
          ? a['transactionDate'].compareTo(b['transactionDate'])
          : b['transactionDate'].compareTo(a['transactionDate']));
    } else {
      transactions = transactions
          .where((transaction) => transaction['type'] == _filter)
          .toList();
      transactions.sort((a, b) => _isAscending
          ? a['transactionDate'].compareTo(b['transactionDate'])
          : b['transactionDate'].compareTo(a['transactionDate']));
    }
    return transactions;
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Filtrar por Categoria'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: const Text('Todas'),
                value: 'all',
                groupValue: _filter,
                onChanged: (value) {
                  setState(() {
                    _filter = value!;
                  });
                  Navigator.of(context).pop();
                },
              ),
              RadioListTile<String>(
                title: const Text('Receitas'),
                value: 'Rendimento',
                groupValue: _filter,
                onChanged: (value) {
                  setState(() {
                    _filter = value!;
                  });
                  Navigator.of(context).pop();
                },
              ),
              RadioListTile<String>(
                title: const Text('Despesas'),
                value: 'Despesa',
                groupValue: _filter,
                onChanged: (value) {
                  setState(() {
                    _filter = value!;
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }
}
