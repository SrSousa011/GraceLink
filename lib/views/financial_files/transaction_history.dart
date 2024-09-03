import 'package:churchapp/views/financial_files/transaction_details.dart';
import 'package:flutter/material.dart';

class TransactionHistoryScreen extends StatelessWidget {
  const TransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final primaryTextColor = isDarkMode ? Colors.white : Colors.black;
    final cardBackgroundColor = isDarkMode ? Colors.grey[800]! : Colors.white;
    final incomeColor =
        isDarkMode ? Colors.lightGreenAccent : Colors.lightGreen;
    final expenseColor = isDarkMode ? Colors.redAccent : Colors.red;
    final secondaryTextColor =
        isDarkMode ? Colors.grey[400]! : Colors.grey[700];

    final List<Map<String, dynamic>> recentTransactions = [
      {
        'title': 'Doação para a Igreja',
        'amount': '€ 50.00',
        'date': '2024-08-25',
        'time': '14:30',
        'user': 'John Doe',
        'type': 'Doação',
      },
      {
        'title': 'Compra de Materiais',
        'amount': '€ 30.00',
        'date': '2024-08-22',
        'time': '10:15',
        'user': 'Jane Smith',
        'type': 'Compra',
      },
      // Adicione mais transações conforme necessário
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Transações'),
      ),
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: recentTransactions.length,
          itemBuilder: (context, index) {
            final transaction = recentTransactions[index];
            final isExpense = transaction['amount']!.startsWith('€') &&
                double.tryParse(transaction['amount']!
                        .substring(2)
                        .replaceAll(',', '.'))! <
                    0;

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              color: cardBackgroundColor,
              child: ListTile(
                leading: Icon(
                  isExpense ? Icons.trending_down : Icons.trending_up,
                  color: isExpense ? expenseColor : incomeColor,
                ),
                title: Text(
                  transaction['title']!,
                  style: TextStyle(
                      color: primaryTextColor, fontWeight: FontWeight.bold),
                ),
                trailing: Text(
                  transaction['amount']!,
                  style: TextStyle(
                    color: isExpense ? expenseColor : incomeColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TransactionDetailScreen(
                        transaction: transaction,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
