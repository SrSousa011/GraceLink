import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:churchapp/views/donations/analyses/monthly_chart.dart';
import 'package:churchapp/views/donations/analyses/yearly_chart.dart';

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

  double monthlyDizimo = 0.0;
  double monthlyOferta = 0.0;
  double monthlyProjetoDoarAAmar = 0.0;
  double monthlyMissaoAfrica = 0.0;

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
          donationValue = double.tryParse(data['donationValue']) ?? 0.0;
        } else {
          donationValue = 0.0;
        }

        final timestamp = (data['timestamp'] as Timestamp).toDate();
        final month = DateFormat('MMMM', 'en_US').format(timestamp);

        totalIncome += donationValue;

        monthlyDonations[month] =
            (monthlyDonations[month] ?? 0) + donationValue;

        switch (data['donationType']) {
          case 'Dizimo':
            monthlyDizimo += donationValue;
            break;
          case 'Oferta':
            monthlyOferta += donationValue;
            break;
          case 'Projeto Doar a Amar':
            monthlyProjetoDoarAAmar += donationValue;
            break;
          case 'Missão África':
            monthlyMissaoAfrica += donationValue;
            break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Renda das Doações'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Doações Mensais',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              MonthlyDonationsChart(
                monthlyDizimo: monthlyDizimo,
                monthlyOferta: monthlyOferta,
                monthlyProjetoDoarAAmar: monthlyProjetoDoarAAmar,
                monthlyMissaoAfrica: monthlyMissaoAfrica,
                totalMonthlyDonations: totalIncome,
                isDarkMode: isDarkMode,
              ),
              const SizedBox(height: 60),
              Text(
                'Rendimento das Doações ao Longo do Ano',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              YearlyDonationsChart(
                monthlyDonations: monthlyDonations,
                isDarkMode: isDarkMode,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
