import 'package:churchapp/views/nav_bar.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:churchapp/views/welcome.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required NavBar drawer});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 77, 93, 233),
              Color.fromARGB(255, 247, 207, 107),
              Color.fromARGB(255, 237, 117, 80),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
    );
  }
}
