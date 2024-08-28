import 'package:flutter/material.dart';
import 'package:churchapp/auth/auth_service.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

const Color tPrimaryColor = Colors.blue;
const Color tDarkColor = Color.fromARGB(255, 255, 255, 255);
const double tFormHeight = 50.0;
const String tEditProfile = 'Atualizar Email';

class ChangeEmailScreen extends StatelessWidget {
  final TextEditingController _currentEmailController = TextEditingController();
  final TextEditingController _newEmailController = TextEditingController();
  final TextEditingController _confirmEmailController = TextEditingController();

  ChangeEmailScreen({super.key});

  Future<void> _changeEmail(BuildContext context) async {
    String currentEmail = _currentEmailController.text.trim();
    String newEmail = _newEmailController.text.trim();
    String confirmEmail = _confirmEmailController.text.trim();

    if (newEmail != confirmEmail) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('O novo email e a confirmação não correspondem'),
        ),
      );
      return;
    }

    try {
      String? userEmail = await AuthenticationService().getCurrentUserEmail();
      if (userEmail != currentEmail) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'O email atual não corresponde ao email associado a esta conta'),
          ),
        );
        return;
      }

      await AuthenticationService()
          .changeEmailWithConfirmation(currentEmail, newEmail);

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email alterado com sucesso')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha ao alterar o email: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alterar Email'),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(LineAwesomeIcons.angle_left_solid),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: tFormHeight - 20),
            TextFormField(
              controller: _currentEmailController,
              decoration: const InputDecoration(
                labelText: 'Email Atual',
                prefixIcon: Icon(LineAwesomeIcons.envelope),
              ),
            ),
            const SizedBox(height: tFormHeight - 20),
            TextFormField(
              controller: _newEmailController,
              decoration: const InputDecoration(
                labelText: 'Novo Email',
                prefixIcon: Icon(LineAwesomeIcons.envelope),
              ),
            ),
            const SizedBox(height: tFormHeight - 20),
            TextFormField(
              controller: _confirmEmailController,
              decoration: const InputDecoration(
                labelText: 'Confirmar Novo Email',
                prefixIcon: Icon(LineAwesomeIcons.envelope),
              ),
            ),
            const SizedBox(height: tFormHeight - 20),
            const SizedBox(height: tFormHeight),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _changeEmail(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: tPrimaryColor,
                  shape: const StadiumBorder(),
                ),
                child: const Text(
                  tEditProfile,
                  style: TextStyle(color: tDarkColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
