import 'package:flutter/material.dart';
import 'package:churchapp/views/admin/admin_painel.dart';
import 'package:churchapp/views/courses/adminDashboard/courses_dashboard.dart';
import 'package:churchapp/views/courses/adminDashboard/subscriber_viewer.dart';
import 'package:churchapp/views/courses/adminDashboard/subscribers_list.dart';
import 'package:churchapp/views/donations/dashboard/donnation_dashboard.dart';
import 'package:churchapp/views/donations/dashboard/donnations_list.dart';
import 'package:churchapp/views/member/become_member_list.dart';
import 'package:churchapp/views/member/become_dashboard.dart';
import 'package:churchapp/views/user_Profile/manegement/about_us.dart';
import 'package:churchapp/services/auth_service.dart';
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
        final args = settings.arguments as Map<String, dynamic>;
        final courseId = args['courseId'] as int;
        return MaterialPageRoute(
          builder: (_) => CoursesDashboard(courseId: courseId),
        );
      case '/subscribers_list':
        final args = settings.arguments as Map<String, dynamic>;
        final courseId = args['courseId'] as int;
        return MaterialPageRoute(
          builder: (_) => SubscribersList(courseId: courseId),
        );
      case '/subscriber_viewer':
        final args = settings.arguments as Map<String, dynamic>;
        final userId = args['userId'] as String;
        final userName = args['userName'] as String;
        final status = args['status'] as bool;
        final registrationDate = args['registrationDate'] as DateTime;
        final courseName = args['courseName'] as String;
        return MaterialPageRoute(
          builder: (_) => SubscriberViewer(
            userId: userId,
            userName: userName,
            status: status,
            registrationDate: registrationDate,
            courseName: courseName,
          ),
        );
      case '/member_list':
        return MaterialPageRoute(builder: (_) => const BecomeMemberList());
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

  static GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();
}
