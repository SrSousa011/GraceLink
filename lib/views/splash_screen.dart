// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:churchapp/views/welcome.dart';

class SplashScreen extends StatefulWidget {
  final Widget drawer; // Define drawer as a parameter

  const SplashScreen({Key? key, required this.drawer}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
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