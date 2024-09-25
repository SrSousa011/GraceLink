import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class DonationIncomes extends StatefulWidget {
  const DonationIncomes({super.key});

  @override
  State<DonationIncomes> createState() => _DonationIncomesState();
}

class _DonationIncomesState extends State<DonationIncomes> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<String, double> monthlyDonations = {
    'January': 0.0,
    'February': 0.0,
    'March': 0.0,
    'April': 0.0,
    'May': 0.0,
    'June': 0.0,
    'July': 0.0,
    'August': 0.0,
    'September': 0.0,
    'October': 0.0,
    'November': 0.0,
    'December': 0.0,
  };

  double totalIncome = 0.0;

  // Adicionando uma propriedade para armazenar as doações mensais sem exibi-las
  List<double> monthlyDonationsList = List.filled(12, 0.0);

  @override
  void initState() {
    super.initState();
    _fetchDonations();
  }

  Future<void> _fetchDonations() async {
    CollectionReference donations = _firestore.collection('donations');
    var snapshot = await donations.get();

    setState(() {
      totalIncome = 0.0;
      monthlyDonations.updateAll((key, value) => 0.0);

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;

        double donationValue;
        if (data['donationValue'] is num) {
          donationValue = (data['donationValue'] as num).toDouble();
        } else if (data['donationValue'] is String) {
          // Try to parse the string to a double
          donationValue = double.tryParse(data['donationValue']) ?? 0.0;
        } else {
          donationValue = 0.0; // or throw an error
        }

        final timestamp = (data['timestamp'] as Timestamp).toDate();

        final month = DateFormat('MMMM', 'en_US').format(timestamp);
        totalIncome += donationValue;

        monthlyDonations[month] =
            (monthlyDonations[month] ?? 0) + donationValue;

        monthlyDonationsList[DateTime.parse(timestamp.toString()).month - 1] +=
            donationValue;
      }
    });
  }

  String _formatTotal(double value) {
    final formatter = NumberFormat.currency(locale: 'pt_BR', symbol: '€');
    return formatter.format(value);
  }

  List<BarChartGroupData> _createChartData() {
    return monthlyDonations.entries.map((entry) {
      return BarChartGroupData(
        x: monthlyDonations.keys.toList().indexOf(entry.key),
        barRods: [
          BarChartRodData(
            toY: entry.value,
            color: Colors.blue,
            width: 20,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
          ),
        ],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Renda das Doações'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total de Renda',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _formatTotal(totalIncome),
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.greenAccent : Colors.green,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Doações por Mês',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 300,
              child: BarChart(
                BarChartData(
                  barGroups: _createChartData(),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 38,
                        getTitlesWidget: (value, meta) {
                          return Text((value.toInt() + 1).toString());
                        },
                      ),
                    ),
                  ),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  backgroundColor: Colors.white.withOpacity(0.5),
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
