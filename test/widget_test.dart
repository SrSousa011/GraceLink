import 'package:churchapp/Login.dart';
import 'package:churchapp/SignUp.dart';
import 'package:flutter/material.dart';
import 'package:churchapp/Welcome.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 255, 255, 255)),
        useMaterial3: true,
      ),
      home: Welcome(title: 'GraceLink'),
      routes: {
        '/Login': (context) => Login(),
        '/SignUp': (context) => SignUp(),
        '/Home': (context) => SignUp(),
      },
    );
  }
}
