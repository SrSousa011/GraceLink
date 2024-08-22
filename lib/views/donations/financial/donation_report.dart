import 'package:churchapp/views/donations/dashboard/donnations_list.dart';
import 'package:churchapp/views/donations/financial/donnation_status.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../dashboard/donnation_receipt.dart';

class DonationReportScreen extends StatefulWidget {
  const DonationReportScreen({super.key});

  @override
  State<DonationReportScreen> createState() => _DonationReportScreenState();
}

class _DonationReportScreenState extends State<DonationReportScreen> {
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
      if (kDebugMode) {
        print('Erro ao buscar doações: $e');
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(child: Text('Usuário não está autenticado.'));
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
    final secondaryTextColor = isDarkMode ? Colors.grey[300]! : Colors.grey;
    final donationValueColor = isDarkMode ? Colors.greenAccent : Colors.green;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: StreamBuilder<DocumentSnapshot>(
        stream: _firestore.collection('users').doc(user.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(
                child: Text('Dados do usuário não encontrados'));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          final userName = data['fullName'] ?? 'Usuário';

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
                        'Erro ao buscar doações: ${donationsSnapshot.error}'));
              }

              final donations = donationsSnapshot.data?.docs ?? [];
              final donationStats = DonationStats.fromDonations(donations);
              final totalBalance = donationStats.totalBalance;
              final monthlyIncome = donationStats.monthlyIncome;

              if (kDebugMode) {
                print('Total Balance: € ${totalBalance.toStringAsFixed(2)}');
                print('Monthly Income: € ${monthlyIncome.toStringAsFixed(2)}');
              }

              return Column(
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
                                  title: 'Saldo Total',
                                  value: '€ ${totalBalance.toStringAsFixed(2)}',
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
                                  title: 'Renda do Mês',
                                  value:
                                      '€ ${monthlyIncome.toStringAsFixed(2)}',
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
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.grey[850]! : Colors.blue[50]!,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(30),
                        bottom: Radius.circular(0),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.account_balance,
                                size: 18, color: accentColor),
                            const SizedBox(width: 8),
                            Text(
                              'Doações Recentes',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: primaryTextColor,
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DonationsList(),
                                  ),
                                );
                              },
                              child: Text(
                                'Ver Todos',
                                style: TextStyle(color: accentColor),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 0.0, left: 16.0),
                      child: donationsSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    isDarkMode ? Colors.white : Colors.black),
                              ),
                            )
                          : ListView.builder(
                              itemCount: donations.length,
                              itemBuilder: (context, index) {
                                final donation = donations[index].data()
                                    as Map<String, dynamic>;
                                final fullName =
                                    donation['fullName'] ?? 'Desconhecido';
                                final donationValue =
                                    donation['donationValue'] ?? '0.00';
                                final donationType =
                                    donation['donationType'] ?? 'Sem tipo';
                                final userId = donation['userId'] ?? '';
                                final paymentProofURL =
                                    donation['photoURL'] ?? '';

                                return StreamBuilder<DocumentSnapshot>(
                                  stream: _firestore
                                      .collection('users')
                                      .doc(userId)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return ListTile(
                                        leading: CircleAvatar(
                                          child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    isDarkMode
                                                        ? Colors.white
                                                        : Colors.black),
                                          ),
                                        ),
                                        title: Text(
                                          'Carregando...',
                                          style: TextStyle(
                                              color: primaryTextColor),
                                        ),
                                      );
                                    }

                                    if (!snapshot.hasData ||
                                        !snapshot.data!.exists) {
                                      return ListTile(
                                        leading: const CircleAvatar(
                                          child: Icon(Icons.person),
                                        ),
                                        title: Text(
                                          donationType,
                                          style: TextStyle(
                                              color: primaryTextColor),
                                        ),
                                        subtitle: Text(
                                          fullName,
                                          style: TextStyle(
                                              color: secondaryTextColor),
                                        ),
                                        trailing: Text(
                                          '+ $donationValue',
                                          style: TextStyle(
                                            color: donationValueColor,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  DonationReceipt(
                                                title: 'Detalhes da Doação',
                                                from: fullName,
                                                time: 'timestamp',
                                                date: 'timestamp',
                                                total: donationValue,
                                                paymentProofURL:
                                                    paymentProofURL,
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    }

                                    final userData = snapshot.data!;
                                    final creatorName =
                                        userData['fullName'] ?? fullName;
                                    final creatorImageUrl =
                                        userData['imagePath'] ?? '';

                                    return ListTile(
                                      leading: creatorImageUrl.isNotEmpty
                                          ? CircleAvatar(
                                              backgroundImage:
                                                  NetworkImage(creatorImageUrl),
                                            )
                                          : const CircleAvatar(
                                              child: Icon(Icons.person),
                                            ),
                                      title: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            donationType,
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                              color: primaryTextColor,
                                            ),
                                          ),
                                          const SizedBox(height: 2.0),
                                          Text(
                                            creatorName,
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              color: secondaryTextColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                      trailing: Text(
                                        '+ $donationValue',
                                        style: TextStyle(
                                          color: donationValueColor,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DonationReceipt(
                                              title: 'Detalhes da Doação',
                                              from: creatorName,
                                              time: 'timestamp',
                                              date: 'timestamp',
                                              total: donationValue,
                                              paymentProofURL: paymentProofURL,
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                    ),
                  ),
                ],
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
    TextStyle? valueStyle,
    bool withShadow = true,
    Color backgroundColor = Colors.white,
    required TextStyle titleStyle,
    Color iconColor = Colors.teal,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: withShadow
            ? [
                BoxShadow(
                  color: iconColor.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ]
            : [],
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: titleStyle,
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: valueStyle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
