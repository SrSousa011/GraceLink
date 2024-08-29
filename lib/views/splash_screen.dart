import 'package:churchapp/route/root.dart';
import 'package:churchapp/views/nav_bar/nav_bar.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:churchapp/views/home/home.dart';
import 'package:churchapp/views/welcome.dart';

const String logoPath = 'assets/icons/logo.png';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.root, required this.drawer});

  final NavBar drawer;
  final Root root;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final user = FirebaseAuth.instance.currentUser;

    Timer(const Duration(seconds: 1), () {
      if (user != null) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 500),
            pageBuilder: (_, __, ___) => Home(
              auth: widget.root.auth,
              userId: user.uid,
            ),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 500),
            pageBuilder: (_, __, ___) => Welcome(
              title: 'GraceLink',
              onSignedIn: () {},
            ),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        );
      }
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
        child: Center(
          child: SizedBox(
            width: 150,
            height: 150,
            child: Image.asset(
              logoPath,
            ),
          ),
        ),
      ),
    );
  }
}
