import 'package:churchapp/views/courses/courseLive/course_card.dart';
import 'package:churchapp/views/courses/service/courses_date.dart';
import 'package:flutter/material.dart';

class CoursesList extends StatelessWidget {
  final List<Course> courses;
  final void Function(String) onUpdateSchedule;
  final void Function(String) onLaunchURL;

  const CoursesList({
    super.key,
    required this.courses,
    required this.onUpdateSchedule,
    required this.onLaunchURL,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];
        final courseName = course.courseName;
        final time = course.getFormattedTime();
        final imageURL = course.imageURL;
        final videoUrl = course.videoUrl;
        final daysOfWeek = course.daysOfWeek ?? 'N/A';

        return CourseCard(
          courseName: courseName,
          time: time,
          imageURL: imageURL,
          videoUrl: videoUrl,
          daysOfWeek: daysOfWeek,
          onPlay: () => videoUrl != null && videoUrl.isNotEmpty
              ? onLaunchURL(videoUrl)
              : null,
          onUpdate: () => onUpdateSchedule(course.courseId),
        );
      },
    );
  }
}
