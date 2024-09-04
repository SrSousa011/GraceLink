import 'package:churchapp/views/financial_files/extras.dart';
import 'package:churchapp/views/financial_files/income/add_income.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:churchapp/views/donations/financial/donnation_status.dart';

class IncomesScreen extends StatelessWidget {
  final DonationStats donationStats;

  const IncomesScreen({super.key, required this.donationStats});

  Future<DonationStats> _fetchDonationStats() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('User not authenticated');
    }

    final querySnapshot = await firestore
        .collection('donations')
        .where('userId', isEqualTo: user.uid)
        .get();

    final donationStats = DonationStats.fromDonations(querySnapshot.docs);
    return donationStats;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receitas'),
        backgroundColor: Colors.green[700],
      ),
      body: FutureBuilder<DonationStats>(
        future: _fetchDonationStats(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('Receitas não encontradas.'));
          }

          final donationStats = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                const SectionTitle(title: 'Receitas'),
                InfoCard(
                  title: 'Total de Receitas',
                  value: 'R\$ ${donationStats.totalBalance.toStringAsFixed(2)}',
                  color: Colors.green[100],
                ),
                const SizedBox(height: 20),
                InfoCard(
                  title: 'Renda Mensal',
                  value:
                      'R\$ ${donationStats.monthlyIncome.toStringAsFixed(2)}',
                  color: Colors.green[100],
                ),
                const SizedBox(height: 20),
                // Add more widgets here if needed
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddIncomeForm(),
            ),
          );
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }
}
