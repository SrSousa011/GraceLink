import 'package:churchapp/theme/theme_provider.dart';
import 'package:churchapp/views/login/local_settings.dart';
import 'package:flutter/material.dart';
import 'package:churchapp/services/auth_method.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:churchapp/services/auth_service.dart';
import 'package:churchapp/views/home/home.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback? onLoggedIn;

  const Login({super.key, required this.auth, this.onLoggedIn});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthMethods _authMethods = AuthMethods();
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  final LocalSettings _localSettings = LocalSettings();

  @override
  void initState() {
    super.initState();
    _localSettings.init();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _loginUser() async {
    String res = await _authMethods.loginUser(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (res.startsWith('Error')) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res),
          duration: const Duration(seconds: 3),
        ),
      );
    } else {
      await _localSettings.setUserLoggedIn(true);
      widget.onLoggedIn?.call();
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Home(
            auth: widget.auth,
            userId: FirebaseAuth.instance.currentUser!.uid,
          ),
        ),
      );
    }
  }

  Future<void> _validateAndSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });
      try {
        await widget.auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
        _loginUser();
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

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final buttonColor = isDarkMode ? const Color(0xFF333333) : Colors.blue;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login',
          style: TextStyle(color: textColor),
        ),
        backgroundColor: buttonColor,
      ),
      backgroundColor: backgroundColor,
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
                _buildEmailField(),
                const SizedBox(height: 20),
                _buildPasswordField(),
                const SizedBox(height: 20),
                _buildLoginButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final borderColor = isDarkMode ? Colors.grey[700] : Colors.grey[400];

    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Email',
        labelStyle: TextStyle(color: borderColor),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: borderColor!),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      validator: _authMethods.validateEmail,
    );
  }

  Widget _buildPasswordField() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final iconColor = isDarkMode ? Colors.grey[700] : Colors.grey[700];

    return TextFormField(
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: TextStyle(color: iconColor),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: iconColor,
          ),
          onPressed: () => setState(() {
            _isPasswordVisible = !_isPasswordVisible;
          }),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[400]!),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      obscureText: !_isPasswordVisible,
      validator: _authMethods.validatePassword,
      onFieldSubmitted: (_) => _validateAndSubmit(),
    );
  }

  Widget _buildLoginButton() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final buttonColor = isDarkMode ? const Color(0xFF333333) : Colors.blue;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: buttonColor,
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(vertical: 15.0),
      ),
      onPressed: _isLoading ? null : _validateAndSubmit,
      child:
          _isLoading ? const CircularProgressIndicator() : const Text('Login'),
    );
  }
}
