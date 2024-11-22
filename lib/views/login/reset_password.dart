import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:churchapp/theme/theme_provider.dart';
import 'package:churchapp/auth/auth_service.dart';
import '../../auth/auth_method.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _confirmEmailController = TextEditingController();
  final AuthMethods authMethods = AuthMethods();
  final AuthenticationService _authService = AuthenticationService();

  @override
  void dispose() {
    _emailController.dispose();
    _confirmEmailController.dispose();
    super.dispose();
  }

  Future<void> _sendPasswordResetEmail() async {
    final email = _emailController.text.trim();
    final confirmEmail = _confirmEmailController.text.trim();

    final emailError = authMethods.validateEmail(email);
    if (emailError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(emailError)),
      );
      return;
    }

    if (email != confirmEmail) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Os e-mails não correspondem')),
      );
      return;
    }

    try {
      // Directly attempt to send the password reset email without checking email existence
      await _authService.sendPasswordResetMail(email);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('E-mail de redefinição de senha enviado')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha ao enviar e-mail: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final textColor =
        isDarkMode ? Colors.grey[300] ?? Colors.grey[400]! : Colors.grey[700]!;
    final borderColor = isDarkMode ? Colors.grey[700]! : Colors.grey[400]!;
    final buttonColor = isDarkMode ? const Color(0xFF333333) : Colors.blue;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Redefinir Senha'),
      ),
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _emailController,
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
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _confirmEmailController,
              decoration: InputDecoration(
                labelText: 'Confirmar Email',
                labelStyle: TextStyle(color: textColor),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: borderColor),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: buttonColor,
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 20.0),
              ),
              onPressed: _sendPasswordResetEmail,
              child: const Text('Enviar Redefinição'),
            ),
          ],
        ),
      ),
    );
  }
}
