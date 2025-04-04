import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:churchapp/auth/auth_service.dart';
import 'package:churchapp/views/home/home.dart';
import 'package:churchapp/views/login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Root extends StatelessWidget {
  final AuthenticationService auth;
  const Root({super.key, required this.auth});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: const [],
      child: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasData) {
            return const Home();
          } else {
            return Login(
              auth: auth,
            );
          }
        },
      ),
    );
  }
}
