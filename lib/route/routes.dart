import 'package:churchapp/views/donations/charts/donnation_incomes.dart';
import 'package:churchapp/views/donations/dashboard/donnation_dashboard.dart';
import 'package:churchapp/views/materials/materials_courses.dart';
import 'package:churchapp/views/member/become_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:churchapp/views/welcome.dart';
import 'package:churchapp/views/home/home.dart';
import 'package:churchapp/views/photos/photos.dart';
import 'package:churchapp/views/videos/videos.dart';
import 'package:churchapp/views/courses/courseLive/course_live.dart';
import 'package:churchapp/views/events/events.dart';
import 'package:churchapp/views/donations/donations.dart';
import 'package:churchapp/views/donations/dashboard/donnations_list.dart';
import 'package:churchapp/views/donations/financial/donation_report.dart';
import 'package:churchapp/views/financial_files/dashboard/financial_files.dart';
import 'package:churchapp/views/courses/courses/courses.dart';
import 'package:churchapp/views/courses/adminDashboard/courses_dashboard.dart';
import 'package:churchapp/views/courses/adminDashboard/courses_dashboard_user.dart';
import 'package:churchapp/views/courses/adminDashboard/subscriber_info.dart';
import 'package:churchapp/views/courses/adminDashboard/subscribers_list.dart';
import 'package:churchapp/views/member/become_member.dart';
import 'package:churchapp/views/member/become_member_list.dart';
import 'package:churchapp/views/member/members_detail.dart';
import 'package:churchapp/views/user_Profile/info/about_us.dart';
import 'package:churchapp/views/admin/admin_painel.dart';

class AppRoutes {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static final Map<String, Widget Function(BuildContext)> routes = {
    '/welcome': (context) => Welcome(title: '', onSignedIn: () {}),
    '/home': (context) => const Home(),
    '/photos': (context) => const PhotoGalleryPage(),
    '/videos': (context) => const Videos(),
    '/course_live': (context) => const CourseLive(),
    '/event_page': (context) => const Events(),
    '/donations': (context) => const Donations(),
    '/donations_list': (context) => const DonationsList(),
    '/donations_income': (context) => const DonationIncomes(),
    '/donations_dashboard': (context) => const DonationsDashboard(),
    '/financial_files': (context) => const FinanceScreen(),
    '/courses': (context) => const Courses(),
    '/courses_dashboard': (context) => const CoursesDashboard(),
    '/courses_user_dashboard': (context) => const CoursesUserDashboard(),
    '/subscribers_list': (context) => const SubscribersList(),
    '/subscriber_info': (context) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
      return SubscriberInfo(
        userId: args?['userId'] ?? '',
        userName: args?['userName'] ?? '',
        status: args?['status'] ?? false,
        registrationDate: args?['registrationDate'] ?? DateTime.now(),
        courseName: args?['courseName'] ?? '',
        imagePath: args?['imagePath'] ?? '',
      );
    },
    '/become_member': (context) => const BecomeMember(),
    '/member_details': (context) => const MemberDetailsScreen(memberId: ''),
    '/manage_course_materials': (context) => const CourseMaterialsPage(),
    '/about_us': (context) => const AboutUs(),
    '/members_dashboard': (context) => const MembersDashboard(),
    '/member_list': (context) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
      final filter = args?['filter'] ?? 'all';
      return BecomeMemberList(filter: filter);
    },
    '/admin_panel': (context) => const AdminPanel(),
    '/donation_report': (context) => const DonationReportScreen(),
  };

  // Gera a rota baseada no nome
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    final routeBuilder = routes[settings.name];
    if (routeBuilder != null) {
      return MaterialPageRoute(
        builder: routeBuilder,
        settings: settings,
      );
    } else {
      return _errorRoute('No route defined for ${settings.name}');
    }
  }

  // Tratamento de erro
  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Center(
          child: Text(message),
        ),
      ),
    );
  }
}
