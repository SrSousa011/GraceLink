import 'package:flutter/material.dart';
import 'package:churchapp/services/auth_service.dart';
import 'package:churchapp/views/home/home.dart';

class Login extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback? onLoggedIn; // Callback can be null

  const Login({super.key, required this.auth, this.onLoggedIn});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFB98B54)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Login'),
      ),
      body: Stack(
        children: [
          _buildLoginForm(),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                _buildEmailSection(),
                const SizedBox(height: 20),
                _buildPasswordSection(),
                const SizedBox(height: 20.0),
                _buildSignUpButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'Email',
          ),
          validator: _validateEmail,
        ),
      ],
    );
  }

  Widget _buildPasswordSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _passwordController,
          decoration: InputDecoration(
            labelText: 'Password',
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
          ),
          obscureText: !_isPasswordVisible,
          validator: _validatePassword,
          onFieldSubmitted: (_) {
            _validateAndSubmit();
          },
        ),
      ],
    );
  }

  Widget _buildSignUpButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _validateAndSubmit,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 90, 175, 249),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      child: const Text('Login'),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!value.contains('@')) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  Future<void> _validateAndSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        await widget.auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
        if (mounted) {
          if (widget.onLoggedIn != null) {
            widget.onLoggedIn!();
          }
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Home(
                auth: widget.auth,
                userId: 'userID', // Replace with the actual user ID
                onSignedOut: () {}, // Define this as needed
              ),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login failed. Please try again.'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }
}
