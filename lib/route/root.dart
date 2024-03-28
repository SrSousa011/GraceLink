import 'package:flutter/material.dart';
import 'package:churchapp/services/auth_service.dart';
import 'package:churchapp/views/home/home.dart';
import 'package:churchapp/views/login.dart';

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
          onSignedIn: () {
            _updateAuthStatus(AuthStatus.loggedIn, _currentUserId);
          },
        );
      case AuthStatus.loggedIn:
        return Home(
          auth: widget.auth,
          userId: _currentUserId,
          onSignedOut: () {
            _updateAuthStatus(AuthStatus.notLoggedIn, '');
            // Navigate to the login screen
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => Login(
                auth: widget.auth,
                onSignedIn: () {}, // No need to handle onSignedIn here
              ),
            ));
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
}
