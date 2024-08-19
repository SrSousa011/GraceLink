import 'package:flutter/material.dart';
import 'transaction_detail.dart';

class TransactionHistory extends StatelessWidget {
  const TransactionHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true, // Adjusts the height of the ListView
      itemCount: transactionData.length,
      itemBuilder: (context, index) {
        final transaction = transactionData[index];
        return ListTile(
          leading: Icon(
            transaction.isPositive ? Icons.trending_up : Icons.trending_down,
            color: transaction.isPositive ? Colors.green : Colors.red,
          ),
          title: Text(transaction.title),
          subtitle: Text('${transaction.from} - ${transaction.date}'),
          trailing: Text(
            '€ ${transaction.amount.toStringAsFixed(2)}',
            style: TextStyle(
              color: transaction.isPositive ? Colors.green : Colors.red,
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    TransactionDetails(transaction: transaction),
              ),
            );
          },
        );
      },
    );
  }
}
