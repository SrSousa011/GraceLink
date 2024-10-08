import 'package:churchapp/views/user_Profile/editProfile/update_profile.dart';
import 'package:flutter/material.dart';
import 'package:churchapp/auth/auth_service.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

const Color tPrimaryColor = Colors.blue;
const Color tDarkColor = Color.fromARGB(255, 255, 255, 255);

class ChangePhoneScreen extends StatelessWidget {
  final TextEditingController _currentPhoneController = TextEditingController();
  final TextEditingController _newPhoneController = TextEditingController();
  final TextEditingController _confirmPhoneController = TextEditingController();

  ChangePhoneScreen({super.key});

  void _changePhone(BuildContext context) async {
    String currentPhone = _currentPhoneController.text.trim();
    String newPhone = _newPhoneController.text.trim();
    String confirmPhone = _confirmPhoneController.text.trim();

    if (newPhone != confirmPhone) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('O novo número e a confirmação não correspondem'),
        ),
      );
      return;
    }

    try {
      final currentUserPhone =
          await AuthenticationService().getCurrentUserPhone();
      if (currentPhone != currentUserPhone) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('O número de telefone atual está incorreto'),
          ),
        );
        return;
      }

      await AuthenticationService()
          .changePhoneWithConfirmation(currentPhone, newPhone);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Número de telefone alterado com sucesso')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha ao alterar o número de telefone: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Alterar Telefone',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
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
              controller: _currentPhoneController,
              decoration: const InputDecoration(
                labelText: 'Telefone Atual',
                prefixIcon: Icon(LineAwesomeIcons.phone_solid),
              ),
            ),
            const SizedBox(height: tFormHeight - 20),
            TextFormField(
              controller: _newPhoneController,
              decoration: const InputDecoration(
                labelText: 'Novo Telefone',
                prefixIcon: Icon(LineAwesomeIcons.phone_solid),
              ),
            ),
            const SizedBox(height: tFormHeight - 20),
            TextFormField(
              controller: _confirmPhoneController,
              decoration: const InputDecoration(
                labelText: 'Confirmar Novo Telefone',
                prefixIcon: Icon(LineAwesomeIcons.phone_solid),
              ),
            ),
            const SizedBox(height: tFormHeight - 20),
            const SizedBox(height: tFormHeight),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _changePhone(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: tPrimaryColor,
                  shape: const StadiumBorder(),
                ),
                child: const Text(
                  'Atualizar Telefone',
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
