import 'package:flutter/material.dart';
import 'package:churchapp/services/auth_service.dart';
import 'package:churchapp/views/welcome.dart';
import 'package:churchapp/views/about_us.dart';
import 'package:churchapp/views/courses/courses.dart';
import 'package:churchapp/views/donations/donations.dart';
import 'package:churchapp/views/events/events.dart';
import 'package:churchapp/views/home/home.dart';
import 'package:churchapp/views/member/become_member.dart';
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
            onSignedOut: () {},
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
      case '/courses':
        return MaterialPageRoute(builder: (_) => const Courses());
      case '/become_member':
        return MaterialPageRoute(builder: (_) => const BecomeMember());
      case '/about_us':
        return MaterialPageRoute(builder: (_) => const AboutUs());
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
}
