import 'package:churchapp/theme/theme_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CoursesDashboard extends StatefulWidget {
  const CoursesDashboard({super.key});

  @override
  State<CoursesDashboard> createState() => _CoursesDashboardState();
}

class _CoursesDashboardState extends State<CoursesDashboard> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int _novasMatriculas = 0;
  int _novosCadastrados = 0;

  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
  }

  Future<void> _fetchDashboardData() async {
    try {
      final trintaDiasAtras = DateTime.now().subtract(const Duration(days: 30));
      final novasMatriculasSnapshot = await _firestore
          .collection('courseregistration')
          .where('registrationDate',
              isGreaterThanOrEqualTo: Timestamp.fromDate(trintaDiasAtras))
          .get();
      setState(() {
        _novasMatriculas = novasMatriculasSnapshot.docs.length;
      });

      final novosCadastradosSnapshot = await _firestore
          .collection(
              'signups') // Replace with the actual collection for sign-ups
          .where('signUpDate',
              isGreaterThanOrEqualTo: Timestamp.fromDate(trintaDiasAtras))
          .get();
      setState(() {
        _novosCadastrados = novosCadastradosSnapshot.docs.length;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao buscar dados do dashboard: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Painel de Cursos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDarkMode
                      ? [Colors.grey[850]!, Colors.grey[800]!]
                      : [Colors.blueAccent, Colors.blue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: isDarkMode ? Colors.black54 : Colors.grey[400]!,
                    blurRadius: 12.0,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Visão Geral dos Cursos',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Aqui está uma visão geral das novas matrículas e dos novos cadastrados',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white70,
                        ),
                  ),
                  const SizedBox(height: 24.0),
                  Wrap(
                    spacing: 16.0, // Space between cards
                    runSpacing: 16.0, // Space between rows
                    children: [
                      _buildSummaryCard(
                        context,
                        title: 'Novas Matrículas',
                        value: _novasMatriculas.toString(),
                      ),
                      _buildSummaryCard(
                        context,
                        title: 'Novos Cadastrados',
                        value: _novosCadastrados.toString(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isDarkMode ? const Color(0xFF333333) : Colors.blue,
                shape: const StadiumBorder(),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed('/courses');
              },
              child: const Text('Lista de Cursos'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isDarkMode ? const Color(0xFF333333) : Colors.blue,
                shape: const StadiumBorder(),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed('/subscribers_list');
              },
              child: const Text('Lista de Cadastrados'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context,
      {required String title, required String value}) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Container(
      constraints: BoxConstraints(maxWidth: 150.0), // Prevents excessive width
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDarkMode
              ? [Colors.grey[850]!, Colors.grey[800]!]
              : [Colors.blueAccent, Colors.blue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? Colors.black54 : Colors.grey[400]!,
            blurRadius: 6.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8.0),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
