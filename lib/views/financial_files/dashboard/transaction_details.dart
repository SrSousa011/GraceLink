import 'package:flutter/material.dart';

class TransactionDetailScreen extends StatelessWidget {
  final Map<String, dynamic> transaction;

  const TransactionDetailScreen({super.key, required this.transaction});

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

    final isExpense = transaction['amount']!.startsWith('€') &&
        double.tryParse(
                transaction['amount']!.substring(2).replaceAll(',', '.'))! <
            0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da Transação'),
      ),
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          color: cardBackgroundColor,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction['title']!,
                  style: TextStyle(
                    fontSize: 24,
                    color: primaryTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Valor: ${transaction['amount']}',
                  style: TextStyle(
                    fontSize: 20,
                    color: isExpense ? expenseColor : incomeColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Data: ${transaction['date']}',
                  style: TextStyle(
                    fontSize: 16,
                    color: secondaryTextColor,
                  ),
                ),
                Text(
                  'Hora: ${transaction['time']}',
                  style: TextStyle(
                    fontSize: 16,
                    color: secondaryTextColor,
                  ),
                ),
                Text(
                  'Usuário: ${transaction['user']}',
                  style: TextStyle(
                    fontSize: 16,
                    color: secondaryTextColor,
                  ),
                ),
                Text(
                  'Tipo: ${transaction['type']}',
                  style: TextStyle(
                    fontSize: 16,
                    color: secondaryTextColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
