import 'package:churchapp/views/financial_files/other.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class IncomesScreen extends StatelessWidget {
  const IncomesScreen({super.key});

  Future<Map<String, double>> _fetchReceitas() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('User not authenticated');
    }

    final querySnapshot = await firestore
        .collection('transactions')
        .where('userId', isEqualTo: user.uid)
        .where('type', isEqualTo: 'income')
        .get();

    double totalReceitas = 0.0;

    for (var doc in querySnapshot.docs) {
      final data = doc.data();
      final amount = (data['amount'] as num?)?.toDouble() ?? 0.0;
      totalReceitas += amount;
    }

    return {'totalReceitas': totalReceitas};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receitas'),
        backgroundColor: Colors.green[700],
      ),
      body: FutureBuilder<Map<String, double>>(
        future: _fetchReceitas(),
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

          final totalReceitas = snapshot.data!['totalReceitas']!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                const SectionTitle(title: 'Receitas'),
                InfoCard(
                  title: 'Total de Receitas',
                  value: 'R\$ ${totalReceitas.toStringAsFixed(2)}',
                  color: Colors.green[100],
                ),
                const SizedBox(height: 20),
                InfoCard(
                  title: 'Detalhes das Receitas',
                  value:
                      'Doações: R\$ 3.000,00\nEventos Especiais: R\$ 1.500,00\nOutras Fontes: R\$ 500,00',
                  color: Colors.green[100],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
