import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:churchapp/theme/theme_provider.dart';

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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    final infoValueColor = isDarkMode ? Colors.grey[300]! : Colors.black;
    final containerColor = isDarkMode ? Colors.grey[800]! : Colors.white;
    final containerShadowColor = isDarkMode
        ? Colors.black.withOpacity(0.3)
        : Colors.black.withOpacity(0.1);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da Transação'),
        backgroundColor: color,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16.0),
            _buildInfoContainer(
              'Descrição:',
              transaction['description'] ?? 'Sem Descrição',
              infoValueColor,
              containerColor,
              containerShadowColor,
            ),
            _buildInfoContainer(
              'Valor:',
              '€${transaction['amount']}',
              infoValueColor,
              containerColor,
              containerShadowColor,
            ),
            _buildInfoContainer(
              'Data:',
              _formatDate(transaction['createdAt']),
              infoValueColor,
              containerColor,
              containerShadowColor,
            ),
            _buildInfoContainer(
              'Hora:',
              transaction['time'] ?? 'N/A',
              infoValueColor,
              containerColor,
              containerShadowColor,
            ),
            _buildInfoContainer(
              'Fonte:',
              transaction['source'] ?? 'N/A',
              infoValueColor,
              containerColor,
              containerShadowColor,
            ),
            _buildInfoContainer(
              'Referência:',
              transaction['reference'] ?? 'N/A',
              infoValueColor,
              containerColor,
              containerShadowColor,
            ),
            _buildInfoContainer(
              'Caminho do Arquivo:',
              transaction['filePath'] ?? 'N/A',
              infoValueColor,
              containerColor,
              containerShadowColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoContainer(String title, String? value, Color textColor,
      Color containerColor, Color shadowColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 6.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              color: textColor,
            ),
          ),
          Expanded(
            child: Text(
              value ?? 'N/A',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 14.0,
                color: textColor.withOpacity(0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(dynamic date) {
    if (date == null) return 'N/A';
    DateTime dt;

    try {
      if (date is Timestamp) {
        dt = date.toDate();
      } else if (date is DateTime) {
        dt = date;
      } else if (date is String) {
        dt = DateTime.parse(date);
      } else {
        return 'N/A';
      }

      final day = dt.day.toString().padLeft(2, '0');
      final month = dt.month.toString().padLeft(2, '0');
      final year = dt.year;
      return '$day/$month/$year';
    } catch (e) {
      return 'N/A';
    }
  }
}
