import 'package:churchapp/views/courses/courseLive/course_live.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:churchapp/theme/theme_provider.dart';

class CoursesUserDashboard extends StatelessWidget {
  const CoursesUserDashboard({super.key});

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      _fetchCourses() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('courses').get();
      return snapshot.docs;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching courses: $e');
      }
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    final Color appBarColor = isDarkMode
        ? Colors.blueGrey[900]!
        : const Color.fromARGB(255, 255, 255, 255);

    final Color containerBackgroundColor =
        isDarkMode ? Colors.blueGrey[800]! : Colors.blueAccent;

    final Color containerBoxShadowColor =
        isDarkMode ? Colors.blueGrey[800]! : Colors.grey[300]!;

    final Color buttonBackgroundColor =
        isDarkMode ? Colors.blueGrey[800]! : Colors.blue;

    const Color summaryCardTextColor = Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Painel de Cursos'),
        backgroundColor: appBarColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
          future: _fetchCourses(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                  child: Text('Erro ao carregar dados: ${snapshot.error}'));
            }

            final documents = snapshot.data ?? [];

            return Column(
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
                        'Aqui está uma visão geral dos cursos disponíveis e das videoaulas.',
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
                            title: 'Lista de Cursos',
                            value: documents.length.toString(),
                            onTap: () {
                              Navigator.of(context).pushNamed('/courses');
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
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
