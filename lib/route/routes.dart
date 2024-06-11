import 'package:churchapp/views/notifications.dart';
import 'package:churchapp/services/auth_service.dart';
import 'package:churchapp/views/videos.dart';
import 'package:churchapp/theme/welcome.dart';
import 'package:churchapp/views/about_us.dart';
import 'package:churchapp/views/courses/courses.dart';
import 'package:churchapp/views/donations/donations.dart';
import 'package:churchapp/views/home/home.dart';
import 'package:churchapp/views/member/become_member.dart';
import 'package:churchapp/views/events/events.dart'; // Import the EventsPage widget
import 'package:churchapp/views/user_profile.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/welcome': // Adicionando a rota 'welcome'
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
      case '/user_profile':
        return MaterialPageRoute(builder: (_) => const UserProfile());
      case '/notifications':
        return MaterialPageRoute(builder: (_) => const Notifications());
      case '/videos':
        return MaterialPageRoute(builder: (_) => const Videos());
      case '/event_page':
        return MaterialPageRoute(
            builder: (_) =>
                const Events()); // Use EventsPage widget for events route
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
