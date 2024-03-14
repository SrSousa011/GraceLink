import 'package:churchapp/firebase_options.dart';
import 'package:churchapp/views/home/home.dart';
import 'package:churchapp/views/member/become_member.dart';
import 'package:churchapp/views/about_us.dart';
import 'package:churchapp/views/nav_bar.dart';
import 'package:churchapp/views/courses/courses.dart';
import 'package:churchapp/views/donations/donations.dart';
import 'package:churchapp/views/signUp/sign_up_personali_Info.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:churchapp/views/login.dart';
import 'package:churchapp/views/splash_screen.dart';
import 'package:churchapp/views/user_profile.dart';
import 'package:churchapp/views/events/events.dart';
import 'package:churchapp/views/welcome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        drawer: NavBar(),
      ),
      routes: {
        '/login': (context) => const Login(),
        '/signUp': (context) => const SignUpPersonalInfo(),
        '/home': (context) => const Home(),
        '/courses': (context) => const Courses(),
        '/user_profile': (context) => const UserProfile(),
        '/event_page': (context) => const Events(),
        '/donations': (context) => const Donations(),
        '/about_us': (context) => const AboutUs(),
        '/become_member': (context) => const BecomeMember(),
        '/welcome': (context) => const Welcome(title: 'GraceLink'),
      },
    );
  }
}
