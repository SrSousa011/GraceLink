import 'package:flutter/material.dart';

class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Opções de ação principal
          ListTile(
            title: const Text('Deactivate User',
                style: TextStyle(color: Colors.orange)),
            leading: const Icon(Icons.remove_circle, color: Colors.orange),
            onTap: () {
              // Lógica para desativar usuário
              _showConfirmationDialog(context, 'Deactivate User',
                  'Are you sure you want to deactivate this user?');
            },
          ),
          ListTile(
            title:
                const Text('Delete User', style: TextStyle(color: Colors.red)),
            leading: const Icon(Icons.delete, color: Colors.red),
            onTap: () {
              // Lógica para excluir usuário
              _showConfirmationDialog(context, 'Delete User',
                  'Are you sure you want to delete this user?');
            },
          ),
          const SizedBox(height: 20),
          // Outras opções
          ListTile(
            title: const Text('View User Details',
                style: TextStyle(color: Colors.white)),
            leading: const Icon(Icons.visibility, color: Colors.white),
            onTap: () {
              // Navegar para a tela de detalhes do usuário
            },
          ),
          ListTile(
            title: const Text('Edit User Details',
                style: TextStyle(color: Colors.white)),
            leading: const Icon(Icons.edit, color: Colors.white),
            onTap: () {
              // Navegar para a tela de edição de detalhes do usuário
            },
          ),
        ],
      ),
    );
  }

  void _showConfirmationDialog(
      BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () {
                // Lógica para confirmar a ação
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
