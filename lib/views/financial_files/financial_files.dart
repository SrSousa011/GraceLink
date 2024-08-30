import 'package:churchapp/views/financial_files/financial_analytics.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FinancialFiles extends StatefulWidget {
  const FinancialFiles({super.key});

  @override
  State<FinancialFiles> createState() => _FinancialFilesState();
}

class _FinancialFilesState extends State<FinancialFiles> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _fetchDonations();
  }

  Future<void> _fetchDonations() async {
    try {
      setState(() {});
    } catch (e) {
      print('Error fetching donations: $e');
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(child: Text('User not authenticated.'));
    }

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final primaryTextColor = isDarkMode ? Colors.white : Colors.black;
    final cardBackgroundColor = isDarkMode ? Colors.grey[800]! : Colors.white;
    final cardTextColor = isDarkMode ? Colors.white : Colors.black;
    final cardShadowColor = isDarkMode
        ? Colors.black.withOpacity(0.5)
        : Colors.black.withOpacity(0.2);
    final accentColor = isDarkMode ? Colors.blueGrey : Colors.blue;
    final incomeColor = isDarkMode ? Colors.greenAccent : Colors.green;
    final expenseColor = isDarkMode ? Colors.redAccent : Colors.red;
    final secondaryTextColor = isDarkMode ? Colors.grey[300]! : Colors.grey;

    final upcomingLaunches = [
      {'title': 'Conferência Anual', 'date': '2024-09-15'},
      {'title': 'Retiro Espiritual', 'date': '2024-10-05'},
    ];

    final recentTransactions = [
      {
        'title': 'Doação para a Igreja',
        'amount': '€ 50.00',
        'date': '2024-08-25'
      },
      {
        'title': 'Compra de Material',
        'amount': '€ 30.00',
        'date': '2024-08-22'
      },
    ];

    return Scaffold(
      backgroundColor: backgroundColor,
      body: StreamBuilder<DocumentSnapshot>(
        stream: _firestore.collection('users').doc(user.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('User data not found.'));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final userName = data['fullName'] ?? 'User';

          return StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('donations').snapshots(),
            builder: (context, donationsSnapshot) {
              if (donationsSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (donationsSnapshot.hasError) {
                return Center(
                    child: Text(
                        'Error fetching donations: ${donationsSnapshot.error}'));
              }

              final donations = donationsSnapshot.data?.docs ?? [];
              final donationStats = DonationStats.fromDonations(donations);
              final totalBalance = donationStats.totalBalance;
              final totalIncome = donationStats.totalIncome;
              final totalExpenses = donationStats.totalExpenses;

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      decoration: BoxDecoration(
                        color: accentColor,
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(80),
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 60.0, left: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Bom Dia',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: primaryTextColor,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                userName,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: primaryTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: const Offset(0.0, -100.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FinancialAnalytics(
                                totalBalance: totalBalance,
                                monthlyIncome: totalIncome,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Center(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 16.0),
                                decoration: BoxDecoration(
                                  color: cardBackgroundColor,
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(30),
                                    bottom: Radius.circular(30),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: cardShadowColor,
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    _buildFinancialCard(
                                      icon: Icons.account_balance_wallet,
                                      title: 'Total Balance',
                                      value:
                                          '€ ${totalBalance.toStringAsFixed(2)}',
                                      valueStyle: TextStyle(
                                        fontSize: 18,
                                        color: cardTextColor,
                                      ),
                                      withShadow: false,
                                      backgroundColor: cardBackgroundColor,
                                      titleStyle: TextStyle(
                                        fontSize: 18,
                                        color: cardTextColor,
                                      ),
                                    ),
                                    _buildFinancialCard(
                                      icon: Icons.trending_up,
                                      title: 'Total Income',
                                      value:
                                          '€ ${totalIncome.toStringAsFixed(2)}',
                                      valueStyle: TextStyle(
                                        fontSize: 14,
                                        color: incomeColor,
                                      ),
                                      withShadow: false,
                                      backgroundColor: Colors.transparent,
                                      titleStyle: TextStyle(
                                        fontSize: 15,
                                        color: cardTextColor,
                                      ),
                                    ),
                                    _buildFinancialCard(
                                      icon: Icons.trending_down,
                                      title: 'Despesas',
                                      value:
                                          '€ ${totalExpenses.toStringAsFixed(2)}',
                                      valueStyle: TextStyle(
                                        fontSize: 14,
                                        color: expenseColor,
                                      ),
                                      withShadow: false,
                                      backgroundColor: Colors.transparent,
                                      titleStyle: TextStyle(
                                        fontSize: 15,
                                        color: cardTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Próximos Lançamentos',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: cardBackgroundColor,
                        borderRadius: BorderRadius.circular(15.0),
                        boxShadow: [
                          BoxShadow(
                            color: cardShadowColor,
                            blurRadius: 6,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: upcomingLaunches.map((launch) {
                          return ListTile(
                            leading: Icon(Icons.event, color: primaryTextColor),
                            title: Text(
                              launch['title']!,
                              style: TextStyle(color: primaryTextColor),
                            ),
                            subtitle: Text(
                              'Data: ${launch['date']}',
                              style: TextStyle(color: secondaryTextColor),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Últimas Transações',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: cardBackgroundColor,
                        borderRadius: BorderRadius.circular(15.0),
                        boxShadow: [
                          BoxShadow(
                            color: cardShadowColor,
                            blurRadius: 6,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: recentTransactions.map((transaction) {
                          return ListTile(
                            leading:
                                Icon(Icons.payment, color: primaryTextColor),
                            title: Text(
                              transaction['title']!,
                              style: TextStyle(color: primaryTextColor),
                            ),
                            trailing: Text(
                              transaction['amount']!,
                              style: TextStyle(
                                color: transaction['amount']!.startsWith('-')
                                    ? expenseColor
                                    : incomeColor,
                              ),
                            ),
                            subtitle: Text(
                              'Data: ${transaction['date']}',
                              style: TextStyle(color: secondaryTextColor),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildFinancialCard({
    required IconData icon,
    required String title,
    required String value,
    required TextStyle valueStyle,
    required TextStyle titleStyle,
    bool withShadow = true,
    required Color backgroundColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: withShadow
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: ListTile(
        leading: Icon(icon, size: 30, color: valueStyle.color),
        title: Text(title, style: titleStyle),
        trailing: Text(value, style: valueStyle),
      ),
    );
  }
}

class DonationStats {
  final double totalBalance;
  final double totalIncome;
  final double totalExpenses;

  DonationStats({
    required this.totalBalance,
    required this.totalIncome,
    required this.totalExpenses,
  });

  factory DonationStats.fromDonations(List<QueryDocumentSnapshot> donations) {
    double totalIncome = 0;
    double totalExpenses = 0;

    for (var donationDoc in donations) {
      final donationData = donationDoc.data() as Map<String, dynamic>;
      final donationValue =
          double.tryParse(donationData['donationValue'] ?? '0.00') ?? 0.00;

      if (donationValue > 0) {
        totalIncome += donationValue;
      } else {
        totalExpenses += donationValue.abs();
      }
    }

    return DonationStats(
      totalBalance: totalIncome - totalExpenses,
      totalIncome: totalIncome,
      totalExpenses: totalExpenses,
    );
  }
}
