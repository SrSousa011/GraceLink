import 'package:churchapp/views/donations/charts/annual_chart.dart';
import 'package:churchapp/views/donations/charts/chart_colors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:churchapp/views/donations/charts/monthly_chart.dart';
import 'package:churchapp/views/donations/charts/yearly_chart.dart';

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
  double currentotalIncome = 0.0;

  double currentDizimo = 0.0;
  double currentOferta = 0.0;
  double currentProjetoDoarAAmar = 0.0;
  double currentMissaoAfrica = 0.0;

  double monthlyDizimo = 0.0;
  double monthlyOferta = 0.0;
  double monthlyProjetoDoarAAmar = 0.0;
  double monthlyMissaoAfrica = 0.0;

  double totalAnnualDizimo = 0.0;
  double totalAnnualOferta = 0.0;
  double totalAnnualProjetoDoarAAmar = 0.0;
  double totalAnnualMissaoAfrica = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchDonations();
    _fetchCurrentMonthDonations();
  }

  Future<void> _fetchCurrentMonthDonations() async {
    CollectionReference donations = _firestore.collection('donations');
    var snapshot = await donations.get();

    setState(() {
      currentotalIncome = 0.0;
      currentDizimo = 0.0;
      currentOferta = 0.0;
      currentProjetoDoarAAmar = 0.0;
      currentMissaoAfrica = 0.0;

      final now = DateTime.now();
      final startOfMonth = DateTime(now.year, now.month, 1);
      final endOfMonth = DateTime(now.year, now.month + 1, 1)
          .subtract(const Duration(days: 1));

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

        if (timestamp
                .isAfter(startOfMonth.subtract(const Duration(seconds: 1))) &&
            timestamp.isBefore(endOfMonth.add(const Duration(days: 1)))) {
          currentotalIncome += donationValue;

          switch (data['donationType']) {
            case 'Dízimo':
              currentDizimo += donationValue;
              break;
            case 'Oferta':
              currentOferta += donationValue;
              break;
            case 'Projeto doar e amar':
              currentProjetoDoarAAmar += donationValue;
              break;
            case 'Missão África':
              currentMissaoAfrica += donationValue;
              break;
          }
        }
      }
    });
  }

  Future<void> _fetchDonations() async {
    CollectionReference donations = _firestore.collection('donations');
    var snapshot = await donations.get();

    setState(() {
      totalIncome = 0.0;
      monthlyDonations.updateAll((key, value) => 0.0);
      totalAnnualDizimo = 0.0;
      totalAnnualOferta = 0.0;
      totalAnnualProjetoDoarAAmar = 0.0;
      totalAnnualMissaoAfrica = 0.0;

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
          case 'Dízimo':
            monthlyDizimo += donationValue;
            totalAnnualDizimo += donationValue;
            break;
          case 'Oferta':
            monthlyOferta += donationValue;
            totalAnnualOferta += donationValue;
            break;
          case 'Projeto doar e amar':
            monthlyProjetoDoarAAmar += donationValue;
            totalAnnualProjetoDoarAAmar += donationValue;
            break;
          case 'Missão África':
            monthlyMissaoAfrica += donationValue;
            totalAnnualMissaoAfrica += donationValue;
            break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  color: DonationChartColors.themeTextColor(context),
                ),
              ),
              const SizedBox(height: 16),
              MonthlyDonationsChart(
                currentDizimo: currentDizimo,
                currentOferta: currentOferta,
                currentProjetoDoarAAmar: currentProjetoDoarAAmar,
                currentMissaoAfrica: currentMissaoAfrica,
                currentotalIncome: currentotalIncome,
              ),
              const SizedBox(height: 60),
              Text(
                'Doações Anuais',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: DonationChartColors.themeTextColor(context),
                ),
              ),
              const SizedBox(height: 16),
              AnnualDonationsChart(
                totalDizimo: totalAnnualDizimo,
                totalOferta: totalAnnualOferta,
                totalProjetoDoarAAmar: totalAnnualProjetoDoarAAmar,
                totalMissaoAfrica: totalAnnualMissaoAfrica,
                totalAnnualDonations: totalIncome,
              ),
              const SizedBox(height: 60),
              Text(
                'Rendimento das Doações ao Longo do Ano',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: DonationChartColors.themeTextColor(context),
                ),
              ),
              const SizedBox(height: 20),
              YearlyDonationsChart(
                monthlyDonations: monthlyDonations,
                isDarkMode: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
