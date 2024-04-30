import 'package:churchapp/views/login.dart';
import 'package:flutter/material.dart';
import 'package:churchapp/services/auth_service.dart';
import 'package:churchapp/views/home/home.dart';

class Root extends StatefulWidget {
  const Root({Key? key, required this.auth}) : super(key: key);

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

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    bool isLoggedIn = await widget.auth.isLoggedIn();
    setState(() {
      _authStatus = isLoggedIn ? AuthStatus.loggedIn : AuthStatus.notLoggedIn;
    });
  }

  void _updateAuthStatus(AuthStatus status, String userId) {
    setState(() {
      _authStatus = status;
      _currentUserId = userId;
    });
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
        // Navega para a tela Home após o login
        return Navigator(
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
              builder: (context) => Home(
                auth: widget.auth,
                userId: _currentUserId,
                onSignedOut: _handleSignedOut,
              ),
            );
          },
        );
    }
  }

  Widget _buildLoadingScreen() {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void _handleLoggedIn() {
    setState(() {
      _authStatus = AuthStatus.loggedIn;
    });
  }

  void _handleSignedOut() {
    setState(() {
      _authStatus = AuthStatus.notLoggedIn;
    });
  }
}
