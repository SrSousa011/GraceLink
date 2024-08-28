import 'package:churchapp/auth/auth_service.dart';
import 'package:flutter/material.dart';

class UserManagementScreen extends StatelessWidget {
  final AuthenticationService _authService = AuthenticationService();

  UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciamento de Usuário'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            title: const Text('Desativar Usuário',
                style: TextStyle(color: Colors.orange)),
            leading: const Icon(Icons.remove_circle, color: Colors.orange),
            onTap: () {
              _showConfirmationDialog(
                context,
                'Desativar Usuário',
                'Tem certeza de que deseja desativar este usuário?',
                () async {
                  await _authService.desactivateUser();
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Usuário desativado com sucesso.')),
                  );
                },
              );
            },
          ),
          ListTile(
            title: const Text('Excluir Usuário',
                style: TextStyle(color: Colors.red)),
            leading: const Icon(Icons.delete, color: Colors.red),
            onTap: () {
              _showConfirmationDialog(
                context,
                'Excluir Usuário',
                'Tem certeza de que deseja excluir este usuário?',
                () async {
                  await _authService.deleteUser();
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Usuário excluído com sucesso.')),
                  );
                },
              );
            },
          ),
          ListTile(
            title: const Text('Enviar Confirmação por E-mail',
                style: TextStyle(color: Colors.blue)),
            leading: const Icon(Icons.email, color: Colors.blue),
            onTap: () {
              _showEmailDialog(context);
            },
          ),
          ListTile(
            title: const Text('Enviar Código de Verificação por Telefone',
                style: TextStyle(color: Colors.blue)),
            leading: const Icon(Icons.phone, color: Colors.blue),
            onTap: () {
              _showPhoneVerificationDialog(context);
            },
          ),
        ],
      ),
    );
  }

  void _showConfirmationDialog(
    BuildContext context,
    String title,
    String message,
    Future<void> Function() onConfirm,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Confirmar'),
              onPressed: () async {
                Navigator.of(context).pop();
                await onConfirm();
              },
            ),
          ],
        );
      },
    );
  }

  void _showEmailDialog(BuildContext context) {
    TextEditingController emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enviar Confirmação por E-mail'),
          content: TextField(
            controller: emailController,
            decoration: const InputDecoration(labelText: 'E-mail'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Enviar'),
              onPressed: () async {
                Navigator.of(context).pop();
                await _authService.sendEmailConfirmation(emailController.text);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Confirmação por e-mail enviada.')),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _showPhoneVerificationDialog(BuildContext context) {
    TextEditingController phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enviar Código de Verificação por Telefone'),
          content: TextField(
            controller: phoneController,
            decoration: const InputDecoration(labelText: 'Número de Telefone'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Enviar'),
              onPressed: () async {
                Navigator.of(context).pop();
                await _authService.sendVerificationCode(phoneController.text);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Código de verificação enviado.')),
                );
              },
            )
          ],
        );
      },
    );
  }
}
