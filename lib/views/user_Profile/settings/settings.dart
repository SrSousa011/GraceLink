import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:churchapp/views/user_Profile/settings/change_email.dart';
import 'package:churchapp/views/user_Profile/settings/change_password.dart';
import 'package:churchapp/views/user_Profile/settings/change_phone.dart';
import 'package:churchapp/auth/auth_service.dart';

const Color tPrimaryColor = Colors.blue;
const Color tDarkColor = Colors.black;

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(LineAwesomeIcons.angle_left_solid),
        ),
        title: const Text(
          'Configurações',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              leading: const Icon(LineAwesomeIcons.envelope),
              title: const Text(
                'Alterar E-mail',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangeEmailScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(LineAwesomeIcons.lock_solid),
              title: const Text(
                'Alterar Senha',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangePasswordScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(LineAwesomeIcons.phone_alt_solid),
              title: const Text(
                'Alterar Telefone',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangePhoneScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(LineAwesomeIcons.envelope),
              title: const Text(
                'Enviar E-mail de Redefinição de Senha',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              onTap: () async {
                final authService = AuthenticationService();
                String? email = await authService.getCurrentUserEmail();

                if (email != null) {
                  try {
                    await authService.sendPasswordResetMail(email);
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                              Text('E-mail de redefinição de senha enviado')),
                    );
                  } catch (e) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'Falha ao enviar e-mail de redefinição de senha: $e')),
                    );
                  }
                } else {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text('Nenhum e-mail encontrado para o usuário')),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
