import 'package:churchapp/auth/auth_method.dart';
import 'package:churchapp/auth/auth_service.dart';
import 'package:churchapp/theme/theme_provider.dart';
import 'package:churchapp/views/home/home.dart';
import 'package:churchapp/views/login/local_settings.dart';
import 'package:churchapp/views/login/reset_password.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  final VoidCallback? onLoggedIn;
  final BaseAuth auth;

  const Login({super.key, this.onLoggedIn, required this.auth});

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

  Future<void> _loginUser() async {
    try {
      final userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      if (userCredential.user != null) {
        await _localSettings.setUserLoggedIn(true);
        widget.onLoggedIn?.call();
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Home(),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            duration: const Duration(seconds: 3),
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

  Future<void> _validateAndSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });
      await _loginUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final textColor = isDarkMode ? Colors.grey[300] : Colors.grey[700];
    final borderColor = isDarkMode ? Colors.grey[700] : Colors.grey[400];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      ),
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          _buildLoginForm(textColor!, borderColor!),
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

  Widget _buildLoginForm(Color textColor, Color borderColor) {
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
                _buildEmailField(textColor, borderColor),
                const SizedBox(height: 20),
                _buildPasswordField(textColor, borderColor),
                const SizedBox(height: 20),
                _buildButtonRow(textColor),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField(Color textColor, Color borderColor) {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Email',
        labelStyle: TextStyle(color: textColor),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      validator: _authMethods.validateEmail,
    );
  }

  Widget _buildPasswordField(Color textColor, Color borderColor) {
    return TextFormField(
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: TextStyle(color: textColor),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: textColor,
          ),
          onPressed: () => setState(() {
            _isPasswordVisible = !_isPasswordVisible;
          }),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: borderColor),
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

  Widget _buildButtonRow(Color textColor) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final buttonColor = isDarkMode ? const Color(0xFF333333) : Colors.blue;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: buttonColor,
            shape: const StadiumBorder(),
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          ),
          onPressed: _isLoading ? null : _validateAndSubmit,
          child: const Text('Login'),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ResetPasswordScreen()),
            );
          },
          child: const Text('Esqueci a Senha'),
        ),
      ],
    );
  }
}
