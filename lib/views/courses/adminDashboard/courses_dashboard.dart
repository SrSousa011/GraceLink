import 'package:churchapp/views/courses/courseLive/course_live.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:churchapp/theme/theme_provider.dart';
import 'package:churchapp/views/courses/adminDashboard/subscribers_list.dart';

class CoursesDashboard extends StatelessWidget {
  const CoursesDashboard({super.key});

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      _fetchCourseRegistrations() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('courseRegistration')
          .get();
      return snapshot.docs;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching course registrations: $e');
      }
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    final Color containerBackgroundColor =
        isDarkMode ? Colors.blueGrey[800]! : Colors.blueAccent;

    final Color containerBoxShadowColor =
        isDarkMode ? Colors.blueGrey[800]! : Colors.grey[300]!;

    final Color buttonBackgroundColor =
        isDarkMode ? Colors.blueGrey[800]! : Colors.blue;

    const Color summaryCardTextColor = Colors.white;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
          future: _fetchCourseRegistrations(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                  child: Text('Erro ao carregar dados: ${snapshot.error}'));
            }

            final documents = snapshot.data ?? [];

            final now = DateTime.now();
            final startOfMonth = DateTime(now.year, now.month, 1);
            final endOfMonth = DateTime(now.year, now.month + 1, 0);

            final newEnrolled = documents.where((doc) {
              final data = doc.data();
              final registrationDate = data['registrationDate'] as Timestamp?;
              if (registrationDate == null) return false;
              final date = registrationDate.toDate();
              return date.isAfter(startOfMonth) && date.isBefore(endOfMonth);
            }).length;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40.0), // Espaçamento adicionado
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
                        'Visão Geral dos Cursos',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              color: summaryCardTextColor,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Aqui está uma visão geral das novas matrículas e dos novos cadastrados',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.white70,
                                ),
                      ),
                      const SizedBox(height: 24.0),
                      Wrap(
                        spacing: 16.0,
                        runSpacing: 16.0,
                        children: [
                          _buildSummaryCard(
                            context,
                            title: 'Total Matrículas',
                            value: documents.length.toString(),
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed('/subscribers_list');
                            },
                          ),
                          _buildSummaryCard(
                            context,
                            title: 'Novos Matrículados',
                            value: newEnrolled.toString(),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const SubscribersList(),
                              ));
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40.0),

                const SizedBox(height: 40.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonBackgroundColor,
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
                    backgroundColor: buttonBackgroundColor,
                    shape: const StadiumBorder(),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const SubscribersList(),
                    ));
                  },
                  child: const Text('Lista de Cadastrados'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonBackgroundColor,
                    shape: const StadiumBorder(),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const CourseLive(),
                    ));
                  },
                  child: const Text('Acesso à Videoaula'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context,
      {required String title,
      required String value,
      required VoidCallback onTap}) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    final Color summaryCardBackgroundColor =
        isDarkMode ? Colors.blueGrey[800]! : Colors.blueAccent;

    final Color summaryCardBoxShadowColor =
        isDarkMode ? Colors.black54 : Colors.grey[300]!;

    const Color summaryCardTextColor = Colors.white;

    return GestureDetector(
      onTap: onTap,
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
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: summaryCardTextColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8.0),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: summaryCardTextColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
