import 'package:churchapp/views/courses/service/courses_date.dart';
import 'package:flutter/material.dart';

class CourseSelectionDropdown extends StatelessWidget {
  final List<Course> courses;
  final ValueChanged<Course?> onChanged;

  const CourseSelectionDropdown({
    super.key,
    required this.courses,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Course>(
      hint: const Text('Select a Course'),
      items: courses.map((course) {
        return DropdownMenuItem<Course>(
          value: course,
          child: Text(course.courseName),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
