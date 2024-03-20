import 'package:churchapp/views/home/home.dart';
import 'package:churchapp/views/member/become_member.dart';
import 'package:churchapp/views/about_us.dart';
import 'package:churchapp/views/nav_bar.dart';
import 'package:churchapp/views/courses/courses.dart';
import 'package:churchapp/views/donations/donations.dart';
import 'package:churchapp/views/events/events.dart';
import 'package:churchapp/views/signUp/signUp_page.dart';
import 'package:churchapp/views/user_profile.dart'; // Update file name and path if necessary
import 'package:churchapp/views/welcome.dart'; // Update file name and path if necessary
import 'package:churchapp/views/login.dart'; // Update file name and path if necessary
import 'package:churchapp/views/splash_screen.dart'; // Update file name and path if necessary
import 'package:flutter/material.dart';

// Define the controller function
Route<dynamic> controller(RouteSettings settings) {
  switch (settings.name) {
    case '/': // Splash Screen Route
      return MaterialPageRoute(
          builder: (_) => const SplashScreen(drawer: NavBar()));
    case '/login': // Login Screen Route
      return MaterialPageRoute(builder: (_) => const Login());
    case '/signup': // Sign Up Screen Route
      return MaterialPageRoute(builder: (_) => const SignUpPage());
    case '/welcome': // Welcome Screen Route
      return MaterialPageRoute(
          builder: (_) => const Welcome(
                title: '',
              ));
    case '/home': // Home Screen Route
      return MaterialPageRoute(builder: (_) => const Home());
    case '/userprofile': // User Profile Screen Route
      return MaterialPageRoute(builder: (_) => const UserProfile());
    case '/navbar': // Navigation Drawer Screen Route
      return MaterialPageRoute(builder: (_) => const NavBar());
    case '/donations': // Navigation Drawer Screen Route
      return MaterialPageRoute(builder: (_) => const Donations());
    case '/courses': // Navigation Drawer Screen Route
      return MaterialPageRoute(builder: (_) => const Courses());
    case '/eventpage': // Event Page Screen Route
      return MaterialPageRoute(builder: (_) => const AboutUs());
    case '/about_us': // Event Page Screen Route
      return MaterialPageRoute(builder: (_) => const Events());
    case '/become_member': // Event Page Screen Route
      return MaterialPageRoute(builder: (_) => const BecomeMember());
    default:
      return MaterialPageRoute(
          builder: (_) =>
              const SplashScreen(drawer: NavBar())); // Default to Splash Screen
  }
}
