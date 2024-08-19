import 'package:churchapp/views/financial/transaction_detail.dart';
import 'package:flutter/material.dart';

class TransactionsPage extends StatelessWidget {
  final List<Transaction> transactions;

  const TransactionsPage({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todas as Transações'),
      ),
      body: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          return ListTile(
            leading: Icon(
              transaction.isPositive
                  ? Icons.arrow_upward
                  : Icons.arrow_downward,
              color: transaction.isPositive ? Colors.green : Colors.red,
            ),
            title: Text(transaction.title),
            subtitle: Text('Recebido de: ${transaction.from}'),
            trailing: Text(
              '${transaction.isPositive ? '+' : '-'} ${transaction.amount.toStringAsFixed(2)} €',
              style: TextStyle(
                color: transaction.isPositive ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TransactionDetails(
                    transaction: transaction,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
