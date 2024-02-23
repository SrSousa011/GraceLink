import 'package:churchapp/SignUp/SignUp2.dart';
import 'package:churchapp/SignUp/SignUp3.dart';
import 'package:churchapp/SignUp/SignUp4.dart';
import 'package:flutter/material.dart';
import 'package:churchapp/SplashScreen.dart';
import 'package:churchapp/Login.dart';
import 'package:churchapp/SignUp/SignUp.dart';
import 'package:churchapp/Welcome.dart';
import 'package:churchapp/Home.dart';
import 'package:churchapp/UserProfile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 90, 175, 249)),
        useMaterial3: true,
      ),
      // Defina a tela de introdução como a tela inicial
      home: const SplashScreen(),
      routes: {
        // Adicione as rotas para outras telas
        '/Login': (context) => const Login(),
        '/SignUp': (context) => const SignUp(),
        '/SignUp2': (context) => const SignUpPage2(),
        '/SignUp3': (context) => const SignUpPage3(),
        '/SignUp4': (context) => const SignUpPage4(),
        '/Home': (context) => Home(),
        '/UserProfile': (context) => UserProfile(),
        '/Welcome': (context) => const Welcome(title: 'GraceLink'),
      },
    );
  }
}
