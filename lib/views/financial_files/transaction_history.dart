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

    final recentTransactions = [
      {
        'title': 'Donation to Church',
        'amount': '€ 50.00',
        'date': '2024-08-25'
      },
      {'title': 'Material Purchase', 'amount': '€ 30.00', 'date': '2024-08-22'},
      {
        'title': 'Event Sponsorship',
        'amount': '€ 100.00',
        'date': '2024-07-15'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History'),
      ),
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: recentTransactions.length,
          itemBuilder: (context, index) {
            final transaction = recentTransactions[index];
            final isExpense = transaction['amount']!.startsWith('-');
            transaction['amount']!.replaceAll('€ ', '');

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
                subtitle: Text(
                  'Date: ${transaction['date']}',
                  style: TextStyle(color: secondaryTextColor),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
