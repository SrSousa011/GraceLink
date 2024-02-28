import 'package:churchapp/views/SignUp/signUp.dart';
import 'package:churchapp/views/donations.dart';
import 'package:flutter/material.dart';
import 'package:churchapp/views/home.dart';
import 'package:churchapp/views/login.dart';
import 'package:churchapp/views/nav_bar.dart';
import 'package:churchapp/views/splash_screen.dart';
import 'package:churchapp/views/user_profile.dart';
import 'package:churchapp/views/event_page.dart';
import 'package:churchapp/views/SignUp/SignUp2.dart';
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
        '/Login': (context) => const Login(),
        '/SignUp': (context) => const SignUp(),
        '/SignUp2': (context) => const SignUpPage2(),
        '/SignUp3': (context) => const SignUpPage3(),
        '/SignUp4': (context) => const SignUpPage4(),
        '/Home': (context) => const Home(),
        '/UserProfile': (context) => const UserProfile(),
        '/EventPage': (context) => const EventPage(),
        '/Donations': (context) => const Donations(),
        '/Welcome': (context) => const Welcome(title: 'GraceLink'),
      },
    );
  }
}
