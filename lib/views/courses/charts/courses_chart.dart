import 'package:churchapp/views/courses/charts/annual_chart.dart';
import 'package:churchapp/views/courses/charts/course_registration.dart';
import 'package:churchapp/views/courses/charts/monthly_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CoursesChartScreen extends StatefulWidget {
  const CoursesChartScreen({super.key});

  @override
  State<CoursesChartScreen> createState() => _CoursesChartScreenState();
}

class _CoursesChartScreenState extends State<CoursesChartScreen> {
  List<CourseRegistration> registrations = [];
  bool isLoading = true;

  double currentCasadosParaSempre = 0.0;
  double currentCursoDiscipulado = 0.0;
  double currentCursosParaNoivos = 0.0;
  double currentEstudoBiblico = 0.0;
  double currentHomenAoMaximo = 0.0;
  double currentMulherUnica = 0.0;
  double currentTotalIncome = 0.0;

  double totalCasadosParaSempre = 0.0;
  double totalCursoDiscipulado = 0.0;
  double totalCursosParaNoivos = 0.0;
  double totalEstudoBiblico = 0.0;
  double totalHomenAoMaximo = 0.0;
  double totalMulherUnica = 0.0;
  double totalTotalIncome = 0.0;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _fetchCourses();
  }

  Future<void> _fetchCourses() async {
    CollectionReference courseRegistration =
        _firestore.collection('courseRegistration');
    var snapshot = await courseRegistration.get();

    double monthlyCasadosParaSempre = 0.0;
    double monthlyDiscipulado = 0.0;
    double monthlyCursosParaNoivos = 0.0;
    double monthlyEstudoBiblico = 0.0;
    double monthlyHomemAoMaximo = 0.0;
    double monthlyMulherUnica = 0.0;

    final currentMonth = DateTime.now().month;
    final currentYear = DateTime.now().year;

    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      double price = _parsePrice(data['price']);
      final timestamp = (data['createdAt'] as Timestamp).toDate();
      final month = timestamp.month;
      final year = timestamp.year;

      if (year == currentYear && month == currentMonth) {
        switch (data['courseName']) {
          case 'Casados para Sempre':
            monthlyCasadosParaSempre += price;
            break;
          case 'Discipulado':
            monthlyDiscipulado += price;
            break;
          case 'Cursos para Noivos':
            monthlyCursosParaNoivos += price;
            break;
          case 'Estudo Bíblico':
            monthlyEstudoBiblico += price;
            break;
          case 'Homem ao Máximo':
            monthlyHomemAoMaximo += price;
            break;
          case 'Mulher Única':
            monthlyMulherUnica += price;
            break;
          default:
            if (kDebugMode) {
              print('Unknown course: ${data['courseName']}');
            }
        }
      }

      if (year == currentYear) {
        switch (data['courseName']) {
          case 'Casados para Sempre':
            totalCasadosParaSempre += price;
            break;
          case 'Discipulado':
            totalCursoDiscipulado += price;
            break;
          case 'Cursos para Noivos':
            totalCursosParaNoivos += price;
            break;
          case 'Estudo Bíblico':
            totalEstudoBiblico += price;
            break;
          case 'Homem ao Máximo':
            totalHomenAoMaximo += price;
            break;
          case 'Mulher Única':
            totalMulherUnica += price;
            break;
        }
      }
    }

    currentTotalIncome = monthlyCasadosParaSempre +
        monthlyDiscipulado +
        monthlyCursosParaNoivos +
        monthlyEstudoBiblico +
        monthlyHomemAoMaximo +
        monthlyMulherUnica;

    totalTotalIncome = totalCasadosParaSempre +
        totalCursoDiscipulado +
        totalCursosParaNoivos +
        totalEstudoBiblico +
        totalHomenAoMaximo +
        totalMulherUnica;

    setState(() {
      currentCasadosParaSempre = monthlyCasadosParaSempre;
      currentCursoDiscipulado = monthlyDiscipulado;
      currentCursosParaNoivos = monthlyCursosParaNoivos;
      currentEstudoBiblico = monthlyEstudoBiblico;
      currentHomenAoMaximo = monthlyHomemAoMaximo;
      currentMulherUnica = monthlyMulherUnica;
      totalCasadosParaSempre = totalCasadosParaSempre;
      totalCursoDiscipulado = totalCursoDiscipulado;
      totalCursosParaNoivos = totalCursosParaNoivos;
      totalEstudoBiblico = totalEstudoBiblico;
      totalHomenAoMaximo = totalHomenAoMaximo;
      totalMulherUnica = totalMulherUnica;
      isLoading = false;
    });
  }

  double _parsePrice(dynamic priceData) {
    if (priceData is num) {
      return (priceData).toDouble();
    } else if (priceData is String) {
      return double.tryParse(priceData) ?? 0.0;
    }
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Venda de Cursos do Mês'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Venda de Cursos'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Venda de cursos por trimestre',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            MonthlyCoursesChart(
              currentCasadosParaSempre: currentCasadosParaSempre,
              currentCursoDiscipulado: currentCursoDiscipulado,
              currentCursosParaNoivos: currentCursosParaNoivos,
              currentEstudoBiblico: currentEstudoBiblico,
              currentHomenAoMaximo: currentHomenAoMaximo,
              currentMulherUnica: currentMulherUnica,
              currentTotalIncome: currentTotalIncome,
              isDarkMode: isDarkMode,
            ),
            const SizedBox(height: 60),
            Text(
              'Cursos Anuais',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            AnnualCoursesChart(
              annualCasadosParaSempre: totalCasadosParaSempre,
              annualCursoDiscipulado: totalCursoDiscipulado,
              annualCursosParaNoivos: totalCursosParaNoivos,
              annualEstudoBiblico: totalEstudoBiblico,
              annualHomenAoMaximo: totalHomenAoMaximo,
              annualMulherUnica: totalMulherUnica,
              annualTotalIncome: totalTotalIncome,
              isDarkMode: isDarkMode,
            ),
          ],
        ),
      ),
    );
  }
}
