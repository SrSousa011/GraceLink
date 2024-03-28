import 'package:churchapp/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key, required this.auth, required this.onSignedIn});
  final BaseAuth auth;
  final VoidCallback onSignedIn;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email cannot be empty';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Invalid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  Future<void> validateAndSubmit() async {
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      // Form is valid, process login here.
      String email = _emailController.text.trim();
      String password = _passwordController.text;
      try {
        UserCredential userCredential =
            await widget.auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        if (kDebugMode) {
          print('Signed in: ${userCredential.user!.uid}');
        }
        // Trigger the onSignedIn callback to navigate to the home page
        widget.onSignedIn(); // This callback should update the _authStatus
      } catch (e) {
        if (kDebugMode) {
          print('Error: $e');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: buildInputs() + buildLoginButton(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> buildInputs() {
    return <Widget>[
      TextFormField(
        controller: _emailController,
        decoration: const InputDecoration(
          labelText: 'Email',
        ),
        validator: _validateEmail,
      ),
      const SizedBox(height: 20.0),
      TextFormField(
        controller: _passwordController,
        obscureText: true,
        decoration: const InputDecoration(
          labelText: 'Password',
        ),
        validator: _validatePassword,
      ),
      const SizedBox(height: 20.0),
    ];
  }

  List<Widget> buildLoginButton() {
    return [
      ElevatedButton(
        onPressed: () {
          validateAndSubmit(); // Calling validateAndSubmit method
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: const Color.fromARGB(255, 90, 175, 249),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        child: const Text('Login'),
      ),
      const SizedBox(height: 20.0),
    ];
  }
}
