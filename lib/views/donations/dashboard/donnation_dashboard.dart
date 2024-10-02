import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:churchapp/theme/theme_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DonationsDashboard extends StatelessWidget {
  const DonationsDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    final Color containerBackgroundColor =
        isDarkMode ? Colors.blueGrey[800]! : Colors.blueAccent;

    final Color containerBoxShadowColor =
        isDarkMode ? Colors.blueGrey[800]! : Colors.grey[300]!;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 60.0, left: 16.0, right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDarkMode
                      ? [containerBackgroundColor, Colors.grey[800]!]
                      : [containerBackgroundColor, Colors.blueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: containerBoxShadowColor,
                    blurRadius: 12.0,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bem-vindo de volta!',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Aqui está uma visão geral de suas doações e relatórios',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white70,
                        ),
                  ),
                  const SizedBox(height: 24.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSummaryBlueCard(
                        context,
                        icon: Icons.monetization_on,
                        title: 'Doações',
                        onPressed: () {
                          Navigator.of(context).pushNamed('/donations');
                        },
                      ),
                      _buildSummaryBlueCard(
                        context,
                        icon: Icons.report,
                        title: 'Relatório de Doações',
                        onPressed: () {
                          Navigator.of(context).pushNamed('/donation_report');
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40.0),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('donations')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                }

                final donations = snapshot.data?.docs ?? [];
                final now = DateTime.now();
                final startOfMonth = DateTime(now.year, now.month, 1);
                final endOfMonth =
                    DateTime(now.year, now.month + 1, 0, 23, 59, 59);

                final monthlyDonations = donations.where((doc) {
                  final timestamp = (doc['timestamp'] as Timestamp).toDate();
                  return timestamp.isAfter(startOfMonth) &&
                      timestamp
                          .isBefore(endOfMonth.add(const Duration(days: 1)));
                }).toList();

                final double monthlyIncome =
                    // ignore: avoid_types_as_parameter_names
                    monthlyDonations.fold(0.0, (sum, doc) {
                  final donationValue = (doc['donationValue'] ?? 0);
                  return sum +
                      (donationValue is num ? donationValue.toDouble() : 0);
                });

                final List<String> currentMonthDonors = [];
                for (var doc in monthlyDonations) {
                  final donorId = doc['userId'];
                  if (!currentMonthDonors.contains(donorId)) {
                    currentMonthDonors.add(donorId);
                  }
                }

                return Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDarkMode
                          ? [containerBackgroundColor, Colors.grey[800]!]
                          : [containerBackgroundColor, Colors.blueAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: isDarkMode ? Colors.black54 : Colors.grey[400]!,
                        blurRadius: 8.0,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Resumo',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildSummaryBlueCard(
                            context,
                            title: 'Renda Mensal',
                            value: '€ ${monthlyIncome.toStringAsFixed(2)}',
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed('/donations_income');
                            },
                          ),
                          _buildSummaryBlueCard(
                            context,
                            title: 'Doadores mês',
                            value: currentMonthDonors.length.toString(),
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed('/donations_list');
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryBlueCard(BuildContext context,
      {required String title,
      String? value,
      VoidCallback? onPressed,
      IconData? icon}) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    final Color summaryCardBackgroundColor =
        isDarkMode ? Colors.blueGrey[800]! : Colors.blueAccent;

    final Color summaryCardBoxShadowColor =
        isDarkMode ? Colors.black54 : Colors.grey[300]!;

    const Color summaryCardTextColor = Colors.white;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 150.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [summaryCardBackgroundColor, Colors.blue[300]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: summaryCardBoxShadowColor,
              blurRadius: 6.0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.white),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: summaryCardTextColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
            if (value != null) ...[
              const SizedBox(height: 8.0),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: summaryCardTextColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onPressed}) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: isDarkMode ? Colors.grey[800] : Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            padding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          ),
          onPressed: onPressed,
          icon: Icon(icon, color: Colors.white),
          label: Text(
            label,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
