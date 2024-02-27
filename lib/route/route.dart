import 'package:churchapp/navBar.dart';
import 'package:churchapp/views/EventPage.dart';
import 'package:churchapp/views/Home.dart';
import 'package:churchapp/views/Login.dart';
import 'package:churchapp/views/SignUp/SignUp2.dart';
import 'package:churchapp/views/SignUp/SignUp3.dart';
import 'package:churchapp/views/SignUp/SignUp4.dart';
import 'package:churchapp/views/SignUp/signUp.dart';
import 'package:churchapp/views/SplashScreen.dart';
import 'package:churchapp/views/UserProfile.dart';
import 'package:churchapp/welcome.dart';
import 'package:flutter/material.dart';

Route<dynamic> controller(RouteSettings settings) {
  switch (settings.name) {
    case '/': // Splash Screen Route
      return MaterialPageRoute(
          builder: (_) => const SplashScreen(drawer: NavBar()));
    case '/login': // Login Screen Route
      return MaterialPageRoute(builder: (_) => const Login());
    case '/signup': // Sign Up Screen Route
      return MaterialPageRoute(builder: (_) => const SignUp());
    case '/signup2': // Sign Up 2 Screen Route
      return MaterialPageRoute(builder: (_) => const SignUpPage2());
    case '/signup3': // Sign Up 3 Screen Route
      return MaterialPageRoute(builder: (_) => const SignUpPage3());
    case '/signup4': // Sign Up 4 Screen Route
      return MaterialPageRoute(builder: (_) => const SignUpPage4());
    case '/welcome': // Welcome Screen Route
      return MaterialPageRoute(builder: (_) => const Welcome(title: 'Welcome'));
    case '/home': // Home Screen Route
      return MaterialPageRoute(builder: (_) => const Home());
    case '/userprofile': // User Profile Screen Route
      return MaterialPageRoute(builder: (_) => UserProfile());
    case '/navbar': // Navigation Drawer Screen Route
      return MaterialPageRoute(builder: (_) => const NavBar());
    case '/eventpage': // Event Page Screen Route
      return MaterialPageRoute(builder: (_) => const EventPage());
    default:
      return MaterialPageRoute(
          builder: (_) =>
              const SplashScreen(drawer: NavBar())); // Default to Splash Screen
  }
}
