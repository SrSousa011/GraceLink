import 'package:churchapp/views/donations/financial/donnation_status.dart';
import 'package:churchapp/views/financial_files/income/anual_chart.dart';
import 'package:churchapp/views/financial_files/income/monthly_chart.dart';
import 'package:churchapp/views/financial_files/dashboard/revenue_data.dart';
import 'package:churchapp/views/financial_files/dashboard/revenue_service.dart';
import 'package:flutter/material.dart';

class IncomesScreen extends StatefulWidget {
  final DonationStats donationStats;

  const IncomesScreen({super.key, required this.donationStats});

  @override
  State<IncomesScreen> createState() => _IncomesScreenState();
}

class _IncomesScreenState extends State<IncomesScreen> {
  RevenueData? revenueData; // Make revenueData nullable
  final RevenueService _revenueService = RevenueService();

  @override
  void initState() {
    super.initState();
    _fetchRevenueData();
  }

  Future<void> _fetchRevenueData() async {
    try {
      revenueData = await _revenueService.fetchAllRevenues();
      setState(() {});
    } catch (e) {
      print('Error fetching revenue data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rendas Overview'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              revenueData != null
                  ? SizedBox(
                      height: 400,
                      child: MonthlyIncomeChart(
                        totalMonthlyOthers: revenueData!.monthlyOthers,
                        totalMonthlyCourses: revenueData!.monthlyCourses,
                        totalMonthlyDonations: revenueData!.monthlyDonations,
                        totalMonthlyReceita: revenueData!.monthlyIncomes,
                        isDarkMode:
                            Theme.of(context).brightness == Brightness.dark,
                      ),
                    )
                  : const Center(child: CircularProgressIndicator()),
              const SizedBox(height: 40),
              revenueData != null
                  ? SizedBox(
                      height: 410,
                      child: AnnualIncomeChart(
                        totalReceita: revenueData!.totalIncomes,
                        totalDonations: revenueData!.totalDonations,
                        totalCourses: revenueData!.totalCourses,
                        totalOthers: revenueData!.totalOthers,
                        isDarkMode:
                            Theme.of(context).brightness == Brightness.dark,
                      ),
                    )
                  : const Center(child: CircularProgressIndicator()),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
