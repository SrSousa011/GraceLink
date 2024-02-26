import 'package:flutter/material.dart';
import 'dart:async';
import 'package:churchapp/Welcome.dart';

class Splash_Screen extends StatefulWidget {
  final Widget drawer; // Define drawer as a parameter

  const Splash_Screen({Key? key, required this.drawer}) : super(key: key);

  @override
  _Splash_ScreenState createState() => _Splash_ScreenState();
}

class _Splash_ScreenState extends State<Splash_Screen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (_, __, ___) => const Welcome(title: 'GraceLink'),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: widget.drawer, // Use the drawer parameter
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/imagens/background_image.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Image.asset(
            'assets/icons/logo.png',
            height: 400,
            width: 400,
          ),
        ),
      ),
    );
  }
}
