import 'package:churchapp/views/admin/admin_painel.dart';
import 'package:churchapp/views/materials/materials_courses.dart';
import 'package:flutter/material.dart';
import 'package:churchapp/views/courses/adminDashboard/courses_dashboard.dart';
import 'package:churchapp/views/courses/adminDashboard/subscribers_list.dart';
import 'package:churchapp/views/courses/adminDashboard/subscriber_viewer.dart';
import 'package:churchapp/views/donations/dashboard/donnation_dashboard.dart';
import 'package:churchapp/views/donations/dashboard/donnations_list.dart';
import 'package:churchapp/views/member/become_member.dart';
import 'package:churchapp/views/member/become_member_list.dart';
import 'package:churchapp/views/member/become_dashboard.dart';
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
      case '/event_page':
        return MaterialPageRoute(builder: (_) => const Events());
      case '/donations':
        return MaterialPageRoute(builder: (_) => const Donations());
      case '/donations_list':
        return MaterialPageRoute(builder: (_) => const DonationsList());
      case '/donations_dashboard':
        return MaterialPageRoute(builder: (_) => const DonationsDashboard());
      case '/courses':
        return MaterialPageRoute(builder: (_) => const Courses());
      case '/courses_dashboard':
        return MaterialPageRoute(builder: (_) => const CoursesDashboard());
      case '/subscribers_list':
        return MaterialPageRoute(
          builder: (_) => const SubscribersList(),
        );
      case '/subscriber_viewer':
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
          builder: (_) => SubscriberViewer(
            userId: args['userId'] as String,
            userName: args['userName'] as String,
            status: args['status'] as bool,
            registrationDate: args['registrationDate'] as DateTime,
            courseName: args['courseName'] as String,
          ),
        );
      case '/member_list':
        return MaterialPageRoute(builder: (_) => const BecomeMemberList());
      case '/become_member':
        return MaterialPageRoute(builder: (_) => const BecomeMember());
      case '/manage_course_materials':
        return MaterialPageRoute(builder: (_) => const CourseMaterialsPage());
      case '/about_us':
        return MaterialPageRoute(builder: (_) => const AboutUs());
      case '/members_dashboard':
        return MaterialPageRoute(builder: (_) => const MembersDashboard());
      case '/admin_panel':
        return MaterialPageRoute(builder: (_) => const AdminPanel());
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
