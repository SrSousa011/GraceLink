import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:churchapp/theme/theme_provider.dart';
import 'package:url_launcher/url_launcher.dart';

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
              _formatDate(transaction['transactionDate']),
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
            _buildFilePathInfo(
              context,
              'Arquivo:',
              transaction['filePath'] ?? '',
              infoValueColor,
              containerColor,
              containerShadowColor,
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoContainer(String title, String value, Color textColor,
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
              value,
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

  Widget _buildFilePathInfo(
    BuildContext context,
    String title,
    String url,
    Color textColor,
    Color containerColor,
    Color shadowColor,
  ) {
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
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.link),
                onPressed: () {
                  if (url.isNotEmpty) {
                    _showUrl(context, url);
                  }
                },
                tooltip: 'Abrir Arquivo',
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showUrl(BuildContext context, String url) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Abrir arquivo'),
          actions: [
            TextButton(
              onPressed: () async {
                final uri = Uri.tryParse(url);
                if (uri != null) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('URL Inválida')),
                    );
                  }
                }
                if (!context.mounted) return;
                Navigator.of(context).pop();
              },
              child: const Text('Abrir'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
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
