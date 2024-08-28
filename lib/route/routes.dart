import 'package:churchapp/views/courses/adminDashboard/courses_dashboard_user.dart';
import 'package:churchapp/views/courses/courseLive/course_live.dart';
import 'package:churchapp/views/courses/adminDashboard/subscriber_info.dart';
import 'package:flutter/material.dart';
import 'package:churchapp/views/member/become_member_list.dart';
import 'package:churchapp/views/member/become_member.dart';
import 'package:churchapp/views/admin/admin_painel.dart';
import 'package:churchapp/views/donations/dashboard/donnations_list.dart';
import 'package:churchapp/views/donations/financial/donation_report.dart';
import 'package:churchapp/views/materials/materials_courses.dart';
import 'package:churchapp/views/member/become_dashboard.dart';
import 'package:churchapp/views/courses/adminDashboard/courses_dashboard.dart';
import 'package:churchapp/views/courses/adminDashboard/subscribers_list.dart';
import 'package:churchapp/views/donations/dashboard/donnation_dashboard.dart';
import 'package:churchapp/views/user_Profile/manegement/about_us.dart';
import 'package:churchapp/auth/auth_service.dart';
import 'package:churchapp/views/welcome.dart';
import 'package:churchapp/views/courses/courses.dart';
import 'package:churchapp/views/donations/donations.dart';
import 'package:churchapp/views/events/events.dart';
import 'package:churchapp/views/home/home.dart';
import 'package:churchapp/views/notifications/notifications.dart';
import 'package:churchapp/views/videos/videos.dart';

class AppRoutes {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/welcome':
        return MaterialPageRoute(
          builder: (_) => Welcome(
            title: '',
            onSignedIn: () {},
          ),
        );
      case '/home':
        return MaterialPageRoute(
          builder: (_) => Home(
            auth: AuthenticationService(),
            userId: '',
          ),
        );
      case '/notifications':
        return MaterialPageRoute(builder: (_) => const Notifications());
      case '/videos':
        return MaterialPageRoute(builder: (_) => const Videos());
      case '/course_live':
        return MaterialPageRoute(builder: (_) => const CourseLive());
      case '/event_page':
        return MaterialPageRoute(builder: (_) => const Events());
      case '/donations':
        return MaterialPageRoute(builder: (_) => const Donations());
      case '/donations_list':
        return MaterialPageRoute(builder: (_) => DonationsList());
      case '/donations_dashboard':
        return MaterialPageRoute(builder: (_) => const DonationsDashboard());
      case '/courses':
        return MaterialPageRoute(builder: (_) => const Courses());
      case '/courses_dashboard':
        return MaterialPageRoute(builder: (_) => const CoursesDashboard());
      case '/courses_user_dashboard':
        return MaterialPageRoute(builder: (_) => const CoursesUserDashboard());
      case '/subscribers_list':
        return MaterialPageRoute(
          builder: (_) => const SubscribersList(),
        );
      case '/subscriber_info':
        final args = settings.arguments as Map<String, dynamic>?;
        if (args == null ||
            !args.containsKey('userId') ||
            !args.containsKey('userName') ||
            !args.containsKey('status') ||
            !args.containsKey('registrationDate') ||
            !args.containsKey('courseName')) {
          return _errorRoute('Missing one or more arguments');
        }
        return MaterialPageRoute(
          builder: (_) => SubscriberInfo(
            userId: args['userId'] as String,
            userName: args['userName'] as String,
            registrationDate: args['registrationDate'] as DateTime,
            courseName: args['courseName'] as String,
            imagePath: args['imagePath'] as String? ?? '',
          ),
        );
      case '/become_member':
        return MaterialPageRoute(builder: (_) => const BecomeMember());
      case '/manage_course_materials':
        return MaterialPageRoute(builder: (_) => const CourseMaterialsPage());
      case '/about_us':
        return MaterialPageRoute(builder: (_) => const AboutUs());
      case '/members_dashboard':
        return MaterialPageRoute(builder: (_) => const MembersDashboard());
      case '/member_list':
        final args = settings.arguments as Map<String, dynamic>?;
        final filter = args?['filter'] ?? 'all'; // Use 'all' as default filter
        return MaterialPageRoute(
          builder: (_) => BecomeMemberList(filter: filter),
        );
      case '/admin_panel':
        return MaterialPageRoute(builder: (_) => const AdminPanel());
      case '/donation_report':
        return MaterialPageRoute(builder: (_) => const DonationReportScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }

  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Center(
          child: Text(message),
        ),
      ),
    );
  }

  static GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();
}
