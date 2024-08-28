import 'package:churchapp/views/courses/courseLive/course_live_list.dart';
import 'package:churchapp/views/courses/courseLive/update_schedule.dart';
import 'package:churchapp/views/courses/service/courses_date.dart';
import 'package:churchapp/views/notifications/notification_course.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CourseLive extends StatefulWidget {
  const CourseLive({super.key});

  @override
  State<CourseLive> createState() => _CourseLiveState();
}

class _CourseLiveState extends State<CourseLive> {
  late Future<List<Course>> _coursesFuture;
  late NotificationService _notificationService;

  @override
  void initState() {
    super.initState();
    _coursesFuture = _fetchCourses();
    _notificationService = NotificationService();
    _notificationService.initialize();
  }

  Future<List<Course>> _fetchCourses() async {
    try {
      var courseSnapshots =
          await FirebaseFirestore.instance.collection('courses').get();
      return courseSnapshots.docs.map((doc) {
        final courseData = doc.data();
        final courseId = doc.id;

        return Course(
          courseId: courseId,
          courseName: courseData['courseName'] ?? 'Unknown Course',
          instructor: courseData['instructor'] ?? '',
          imageURL: courseData['imageURL'] ?? '',
          description: courseData['description'] ?? '',
          price: (courseData['price'] as num).toDouble(),
          registrationDeadline:
              (courseData['registrationDeadline'] as Timestamp).toDate(),
          descriptionDetails: courseData['descriptionDetails'] ?? '',
          time: courseData['time'] as Timestamp?,
          videoUrl: courseData['videoUrl'],
          daysOfWeek: courseData['daysOfWeek'],
        );
      }).toList();
    } catch (e) {
      debugPrint('Erro ao buscar cursos: $e');
      return [];
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
              child: FutureBuilder<List<Course>>(
                future: _coursesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
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
