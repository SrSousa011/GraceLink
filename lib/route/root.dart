import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:churchapp/services/auth_service.dart';
import 'package:churchapp/views/login/login.dart';
import 'package:churchapp/views/home/home.dart';

class Root extends StatefulWidget {
  const Root({super.key, required this.auth});

  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => _RootState();
}

enum AuthStatus {
  notDetermined,
  notLoggedIn,
  loggedIn,
}

class _RootState extends State<Root> {
  AuthStatus _authStatus = AuthStatus.notDetermined;
  late String _currentUserId;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    try {
      bool isLoggedIn = await widget.auth.isLoggedIn();
      if (mounted) {
        setState(() {
          _authStatus =
              isLoggedIn ? AuthStatus.loggedIn : AuthStatus.notLoggedIn;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error checking login status: $e');
      }
      if (mounted) {
        setState(() {
          _authStatus = AuthStatus.notLoggedIn;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (_authStatus) {
      case AuthStatus.notDetermined:
        return _buildLoadingScreen();
      case AuthStatus.notLoggedIn:
        return Login(
          auth: widget.auth,
          onLoggedIn: _handleLoggedIn,
        );
      case AuthStatus.loggedIn:
        return _buildHomeScreen();
    }
  }

  Widget _buildLoadingScreen() {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildHomeScreen() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => Home(
            auth: widget.auth,
            userId: _currentUserId,
            onSignedOut: _handleSignedOut,
          ),
        ),
      );
    });
    return _buildLoadingScreen();
  }

  void _handleLoggedIn() {
    if (mounted) {
      setState(() {
        _authStatus = AuthStatus.loggedIn;
      });
    }
  }

  void _handleSignedOut() {
    if (mounted) {
      setState(() {
        _authStatus = AuthStatus.notLoggedIn;
      });
    }
  }
}
