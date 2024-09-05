import 'package:churchapp/views/financial_files/upcomingEvents/add_income.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UpcomingEventsScreen extends StatelessWidget {
  const UpcomingEventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    //final primaryTextColor = isDarkMode ? Colors.white : Colors.black;
    final cardBackgroundColor = isDarkMode ? Colors.grey[800]! : Colors.white;
    final secondaryTextColor =
        isDarkMode ? Colors.grey[400]! : Colors.grey[700];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Próximos Lançamentos'),
      ),
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _fetchTransactions(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No transactions found.'));
            }

            final transactions = snapshot.data!;

            return ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                final isIncome = transaction['category'] == 'income';
                final amount = transaction['amount'];
                final color = isIncome ? Colors.green : Colors.red;

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  color: cardBackgroundColor,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16.0),
                    title: Text(
                      transaction['description'] ?? 'No Description',
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      'Date: ${transaction['createdAt']}\n'
                      'Amount: €$amount',
                      style: TextStyle(color: secondaryTextColor),
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
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddIncomeForm(),
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
      throw Exception('User not authenticated');
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
        'createdAt': data['createdAt']?.toDate().toString() ?? 'N/A',
        'createdBy': data['createdBy'] ?? 'N/A',
        'date': data['date'] ?? 'N/A',
        'description': data['description'] ?? 'No Description',
        'reference': data['reference'] ?? 'N/A',
        'source': data['source'] ?? 'N/A',
        'time': data['time'] ?? 'N/A',
        'type': data['type'] ?? 'N/A',
      };
    }).toList();
  }
}

class TransactionDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> transaction;
  final Color color;

  const TransactionDetailsScreen({
    super.key,
    required this.transaction,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Details'),
        backgroundColor: color,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildDetailRow(
                'Description:', transaction['description'] ?? 'No Description'),
            _buildDetailRow('Amount:', '€${transaction['amount']}'),
            _buildDetailRow('Date:', transaction['createdAt']),
            _buildDetailRow('Time:', transaction['time']),
            _buildDetailRow('Source:', transaction['source'] ?? 'N/A'),
            _buildDetailRow('Reference:', transaction['reference'] ?? 'N/A'),
            _buildDetailRow(
                'Created By:', transaction['createdBy'] ?? 'Unknown'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
