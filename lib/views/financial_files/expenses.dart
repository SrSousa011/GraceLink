import 'package:churchapp/views/financial_files/extras.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ExpensesScreen extends StatelessWidget {
  const ExpensesScreen({super.key});

  Future<Map<String, double>> _fetchDespesas() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('User not authenticated');
    }

    final querySnapshot = await firestore
        .collection('transactions')
        .where('userId', isEqualTo: user.uid)
        .where('type', isEqualTo: 'expense')
        .get();

    double totalDespesas = 0.0;

    for (var doc in querySnapshot.docs) {
      final data = doc.data();
      final amount = (data['amount'] as num?)?.toDouble() ?? 0.0;
      totalDespesas += amount;
    }

    return {'totalDespesas': totalDespesas};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Despesas'),
        backgroundColor: Colors.red[700],
      ),
      body: FutureBuilder<Map<String, double>>(
        future: _fetchDespesas(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('Despesas não encontradas.'));
          }

          final totalDespesas = snapshot.data!['totalDespesas']!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                const SectionTitle(title: 'Despesas'),
                InfoCard(
                  title: 'Total de Despesas',
                  value: 'R\$ ${totalDespesas.toStringAsFixed(2)}',
                  color: Colors.red[100],
                ),
                const SizedBox(height: 20),
                InfoCard(
                  title: 'Detalhes das Despesas',
                  value:
                      'Salários: R\$ 1.200,00\nContas de Serviços Públicos: R\$ 800,00\nManutenção: R\$ 500,00\nSuprimentos: R\$ 300,00',
                  color: Colors.red[100],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
