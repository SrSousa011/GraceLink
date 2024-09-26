import 'package:churchapp/views/donations/financial/donnation_status.dart';
import 'package:churchapp/views/financial_files/income/anual_chart.dart';
import 'package:churchapp/views/financial_files/income/monthly_chart.dart';
import 'package:churchapp/views/financial_files/revenue_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class IncomesScreen extends StatefulWidget {
  final DonationStats donationStats;

  const IncomesScreen({super.key, required this.donationStats});

  @override
  State<IncomesScreen> createState() => _IncomesScreenState();
}

class _IncomesScreenState extends State<IncomesScreen> {
  final RevenueService _revenueService = RevenueService();

  double totalDonations = 0.0;
  double totalCourseRevenue = 0.0;
  double totalOthers = 0.0;
  double totalReceita = 0.0;

  double totalMonthlyReceitas = 0.0;
  double totalMonthlyDonations = 0.0;
  double totalMonthlyCourses = 0.0;
  double totalMonthlyOthers = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchAllRevenues();
  }

  Future<void> _fetchAllRevenues() async {
    try {
      final revenues = await _revenueService.fetchAllRevenues();
      setState(() {
        totalDonations = revenues['totalDonations'] ?? 0.0;
        totalCourseRevenue = revenues['totalCourseRevenue'] ?? 0.0;
        totalOthers = revenues['totalIncome'] ?? 0.0;

        totalReceita = totalDonations + totalCourseRevenue + totalOthers;
      });

      final currentMonth = DateTime.now().month;
      final monthName = _getMonthName(currentMonth);

      final monthlyRevenues =
          await _revenueService.fetchMonthlyRevenues(widget.donationStats);
      final monthlyData = monthlyRevenues[monthName] ??
          {
            'totalReceitas': 0.0,
            'totalDonations': 0.0,
            'monthlyDonations': 0.0,
            'totalCourseRevenue': 0.0,
            'totalIncome': 0.0,
          };

      setState(() {
        totalMonthlyReceitas = monthlyData['totalReceitas'] ?? 0.0;
        totalMonthlyDonations = monthlyData['totalDonations'] ?? 0.0;
        totalMonthlyCourses = monthlyData['totalCourseRevenue'] ?? 0.0;
        totalMonthlyOthers = monthlyData['totalIncome'] ?? 0.0;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching revenues: $e');
      }
    }
  }

  String _getMonthName(int month) {
    const monthNames = [
      'Janeiro',
      'Fevereiro',
      'Março',
      'Abril',
      'Maio',
      'Junho',
      'Julho',
      'Agosto',
      'Setembro',
      'Outubro',
      'Novembro',
      'Dezembro'
    ];
    return monthNames[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Incomes Overview'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 400,
                child: MonthlyIncomeChart(
                  totalMonthlyOthers: totalMonthlyOthers,
                  totalMonthlyCourses: totalMonthlyCourses,
                  totalMonthlyDonations: totalMonthlyDonations,
                  totalMonthlyReceita: totalMonthlyReceitas,
                  isDarkMode: Theme.of(context).brightness == Brightness.dark,
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                height: 410,
                child: AnnualIncomeChart(
                  totalReceita: totalReceita,
                  totalDonations: totalDonations,
                  totalCourses: totalCourseRevenue,
                  totalOthers: totalOthers,
                  isDarkMode: Theme.of(context).brightness == Brightness.dark,
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
