import 'package:churchapp/views/SignUp/signUp.dart';
import 'package:churchapp/views/courses.dart';
import 'package:churchapp/views/donations.dart';
import 'package:flutter/material.dart';
import 'package:churchapp/views/home.dart';
import 'package:churchapp/views/login.dart';
import 'package:churchapp/views/nav_bar.dart';
import 'package:churchapp/views/splash_screen.dart';
import 'package:churchapp/views/user_profile.dart';
import 'package:churchapp/views/events.dart';
import 'package:churchapp/views/SignUp/signUp2.dart';
import 'package:churchapp/views/SignUp/signUp3.dart';
import 'package:churchapp/views/SignUp/signUp4.dart';
import 'package:churchapp/views/welcome.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Comunidade Connect',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 90, 175, 249),
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(
        drawer: NavBar(), // Passe o MenuDrawer como parâmetro
      ),
      routes: {
        '/login': (context) => const Login(),
        '/signUp': (context) => const SignUp(),
        '/signUp2': (context) => const SignUpPage2(),
        '/signUp3': (context) => const SignUpPage3(),
        '/signUp4': (context) => const SignUpPage4(),
        '/home': (context) => const Home(),
        '/courses': (context) => const Courses(),
        '/user_profile': (context) => const UserProfile(),
        '/event_page': (context) => const Events(),
        '/donations': (context) => const Donations(),
        '/welcome': (context) => const Welcome(title: 'GraceLink'),
      },
    );
  }
}
