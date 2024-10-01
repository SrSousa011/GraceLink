import 'package:churchapp/views/courses/charts/course_registration.dart';
import 'package:intl/intl.dart';

class CoursesStats {
  final double totalCourses;
  final List<double> monthlyCourses;

  CoursesStats({
    required this.totalCourses,
    required this.monthlyCourses,
  });

  static CoursesStats fromRegistrations(
      List<CourseRegistration> registrations) {
    double totalCourses = 0;
    List<double> monthlyCourses = List.filled(12, 0);

    for (var registration in registrations) {
      totalCourses += registration.price;

      final month = registration.registrationDate.month - 1;

      monthlyCourses[month] += registration.price;
    }

    return CoursesStats(
      totalCourses: totalCourses,
      monthlyCourses: monthlyCourses,
    );
  }

  factory CoursesStats.fromMap(Map<String, dynamic> map) {
    return CoursesStats(
      totalCourses: (map['totalCourses'] as num?)?.toDouble() ?? 0.0,
      monthlyCourses: (map['monthlyCourses'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          List.filled(12, 0.0),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalCourses': totalCourses,
      'monthlyCourses': monthlyCourses,
    };
  }

  String formatCurrency(double value) {
    final formatter = NumberFormat.currency(locale: 'pt_BR', symbol: '€');
    return formatter.format(value);
  }

  double get monthlyIncome {
    return monthlyCourses.reduce((a, b) => a + b);
  }
}
