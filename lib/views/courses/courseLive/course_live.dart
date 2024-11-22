import 'package:churchapp/views/courses/courseLive/course_live_list.dart';
import 'package:churchapp/views/courses/courseLive/update_schedule.dart';
import 'package:churchapp/views/courses/service/courses_date.dart';
import 'package:churchapp/views/courses/service/courses_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class CourseLive extends StatefulWidget {
  const CourseLive({super.key});

  @override
  State<CourseLive> createState() => _CourseLiveState();
}

class _CourseLiveState extends State<CourseLive> {
  late Future<List<Course>> _coursesFuture;
  late CoursesService _coursesService;
  bool _loading = false;
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _coursesService = CoursesService();
    _fetchUserRole();
    _coursesFuture = _fetchCourses();
  }

  Future<void> _fetchUserRole() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      setState(() {
        _isAdmin = userDoc.data()?['role'] == 'admin';
      });
    } catch (e) {
      debugPrint('Erro ao buscar papel do usuário: $e');
    }
  }

  Future<List<Course>> _fetchCourses() async {
    setState(() => _loading = true);

    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        setState(() => _loading = false);
        return [];
      }

      final courses = await _coursesService.getCourses();

      if (_isAdmin) {
        return courses;
      } else {
        final registrations = await Future.wait(
          courses.map((course) async {
            final isRegistered = await _coursesService.isUserAlreadySubscribed(
              courseId: course.courseId,
              userId: userId,
            );
            return {
              'course': course,
              'isRegistered': isRegistered,
            };
          }),
        );

        final filteredCourses = registrations
            .where((entry) => entry['isRegistered'] as bool)
            .map((entry) => entry['course'] as Course)
            .toList();

        return filteredCourses;
      }
    } catch (e) {
      debugPrint('Erro ao buscar cursos: $e');
      return [];
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw Exception('Não foi possível abrir o link $url');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao abrir o link: $e')),
        );
      }
    }
  }

  void _navigateToUpdateSchedule(String courseId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => UpdateScheduleScreen(courseId: courseId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Videoaulas ao Vivo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16.0),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : FutureBuilder<List<Course>>(
                      future: _coursesFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        }
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(
                              child: Text('Nenhum curso disponível.'));
                        }

                        return CoursesList(
                          courses: snapshot.data!,
                          onUpdateSchedule: _navigateToUpdateSchedule,
                          onLaunchURL: _launchURL,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
