<<<<<<< HEAD
<<<<<<< HEAD
import 'package:churchapp/navBar.dart';
import 'package:churchapp/views/EventPage.dart';
import 'package:churchapp/views/SignUp/signUp.dart';
import 'package:churchapp/views/UserProfile.dart';
import 'package:flutter/material.dart';
import 'package:churchapp/views/SplashScreen.dart';
=======
import 'package:flutter/material.dart';
import 'package:churchapp/navBar.dart';
import 'package:churchapp/views/EventPage.dart';
import 'package:churchapp/views/Home.dart';
>>>>>>> 41a00e2 ([ADD]  circular notification badge to notifications in NavBar)
import 'package:churchapp/views/Login.dart';
=======
import 'package:churchapp/views/nav-bar.dart';
import 'package:churchapp/views/splash-screen.dart';
import 'package:churchapp/views/user-profile.dart';
import 'package:flutter/material.dart';
import 'package:churchapp/views/event-Page.dart';
import 'package:churchapp/views/home.dart';
import 'package:churchapp/views/login.dart';
>>>>>>> c2f1437 ([ADD]  Refactoring)
import 'package:churchapp/views/SignUp/SignUp2.dart';
import 'package:churchapp/views/SignUp/SignUp3.dart';
import 'package:churchapp/views/SignUp/SignUp4.dart';
<<<<<<< HEAD
import 'package:churchapp/views/Welcome.dart';
import 'package:churchapp/views/Home.dart';
=======
import 'package:churchapp/views/SignUp/signUp.dart';
<<<<<<< HEAD
import 'package:churchapp/views/SplashScreen.dart';
import 'package:churchapp/views/UserProfile.dart';
import 'package:churchapp/views/Welcome.dart';
>>>>>>> 41a00e2 ([ADD]  circular notification badge to notifications in NavBar)
=======
import 'package:churchapp/views/welcome.dart';
>>>>>>> c2f1437 ([ADD]  Refactoring)

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
        '/Welcome': (context) => const Welcome(title: 'GraceLink'),
      },
    );
  }
}
