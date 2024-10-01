import 'package:churchapp/views/donations/financial/donnation_status.dart';
import 'package:churchapp/views/financial_files/income/anual_chart.dart';
import 'package:churchapp/views/financial_files/income/monthly_chart.dart';
import 'package:churchapp/views/financial_files/revenue_data.dart';
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
  double totalCourses = 0.0;
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
      final revenueData = await _revenueService.fetchData();

      setState(() {
        totalDonations = revenueData.totalDonations;
        totalCourses = revenueData.totalCourses;
        totalOthers = revenueData.totalOthers;

        totalReceita = totalDonations + totalCourses + totalOthers;

        String currentMonth = RevenueData.getMonthName(DateTime.now().month);

        totalMonthlyDonations =
            revenueData.donationsPerMonth[currentMonth] ?? 0.0;
        totalMonthlyCourses = revenueData.coursesPerMonth[currentMonth] ?? 0.0;
        totalMonthlyOthers = revenueData.othersPerMonth[currentMonth] ?? 0.0;
        totalMonthlyReceitas =
            totalMonthlyDonations + totalMonthlyCourses + totalMonthlyOthers;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching revenues: $e');
      }
    }
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
                  totalCourses: totalCourses,
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
