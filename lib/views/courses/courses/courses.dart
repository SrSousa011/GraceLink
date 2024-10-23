import 'package:churchapp/views/courses/courses/update_courses.dart';
import 'package:churchapp/views/courses/service/courses_date.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:churchapp/views/courses/courses_details.dart';
import 'package:churchapp/views/courses/service/courses_service.dart';
import 'package:churchapp/views/nav_bar/nav_bar.dart';

class Courses extends StatefulWidget {
  const Courses({super.key});

  @override
  State<Courses> createState() => _CoursesState();
}

class _CoursesState extends State<Courses> {
  final CoursesService _coursesService = CoursesService();
  late Future<List<Course>> _coursesFuture;
  late String _userRole;

  @override
  void initState() {
    super.initState();
    _coursesFuture = _coursesService.getCourses();
    _fetchUserRole();
  }

  Future<void> _fetchUserRole() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      final userData = userDoc.data();
      setState(() {
        _userRole = userData?['role'] ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final gradientColors = isDarkMode
        ? [const Color(0xFF3C3C3C), const Color(0xFF5A5A5A)]
        : [const Color(0xFFFFD59C), const Color(0xFF62CFF7)];
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final subtitleColor = isDarkMode ? Colors.white70 : Colors.black54;
    final descriptionColor = isDarkMode ? Colors.white70 : Colors.black87;
    final priceColor = isDarkMode ? Colors.white70 : Colors.black54;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cursos'),
        centerTitle: true,
      ),
      drawer: const NavBar(),
      body: FutureBuilder<List<Course>>(
        future: _coursesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No courses available.'));
          }

          final coursesList = snapshot.data!;

          return ListView.builder(
            itemCount: coursesList.length,
            itemBuilder: (context, index) {
              final course = coursesList[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CoursesDetails(
                          course: course,
                          coursesService: _coursesService,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    margin: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 10.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: gradientColors,
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 150.0,
                          height: 230.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(course.imageURL),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                course.courseName,
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                course.instructor,
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.normal,
                                  color: subtitleColor,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                course.description,
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.normal,
                                  color: descriptionColor,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                '${course.price} €',
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.normal,
                                  color: priceColor,
                                ),
                              ),
                              if (_userRole == 'admin') ...[
                                const SizedBox(height: 8.0),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              UpdateCourseScreen(
                                            courseId: course.courseId,
                                          ),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: isDarkMode
                                          ? Colors.grey
                                          : Colors.blue,
                                    ),
                                    child: const Text('Atualizar'),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
