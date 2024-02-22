import 'package:flutter/material.dart';
import 'package:churchapp/Welcome.dart'; // Make sure to import Welcome widget
import 'package:churchapp/Login.dart'; // Make sure to import Login widget
import 'package:churchapp/SignUp.dart'; // Make sure to import SignUp widget
import 'package:churchapp/Home.dart'; // Assuming Home widget is defined and imported correctly
import 'package:churchapp/UserProfile.dart'; // Assuming UserProfile widget is defined and imported correctly

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
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 90, 175, 249)),
        useMaterial3: true,
      ),
      home: Welcome(title: 'GraceLink'),
      routes: {
        '/Login': (context) => Login(),
        '/SignUp': (context) => SignUp(),
        '/Home': (context) => Home(),
        '/UserProfile': (context) => UserProfile()
      },
    );
  }
}
