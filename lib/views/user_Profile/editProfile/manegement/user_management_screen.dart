import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:churchapp/auth/auth_service.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  _UserManagementScreenState createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final AuthenticationService _authService = AuthenticationService();
  bool _isEmailVerified = false;
  bool _isPhoneVerified = false;

  @override
  void initState() {
    super.initState();
    _checkEmailVerificationStatus();
    _checkPhoneVerificationStatus();
  }

  Future<void> _checkEmailVerificationStatus() async {
    bool isVerified = await _authService.getEmailVerificationStatus();
    setState(() {
      _isEmailVerified = isVerified;
    });
  }

  Future<void> _checkPhoneVerificationStatus() async {
    bool isVerified = await _authService.getPhoneVerificationStatus();
    setState(() {
      _isPhoneVerified = isVerified;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = MediaQuery.of(context).platformBrightness ==
        Brightness.dark; // Verifica se o modo escuro está ativo

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciamento de Usuário',
            style: TextStyle(fontSize: 18)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildEmailConfirmationTile(context, isDarkMode),
          _buildPhoneVerificationTile(context, isDarkMode),
          _buildDeleteUserTile(context, isDarkMode),
        ],
      ),
    );
  }

  Widget _buildDeleteUserTile(BuildContext context, bool isDarkMode) {
    return ListTile(
      title: Text(
        'Excluir Usuário',
        style: TextStyle(
            color: isDarkMode
                ? Colors.red[400]
                : Colors.red), // Muda a cor dependendo do modo
      ),
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
              const SnackBar(content: Text('Usuário excluído com sucesso.')),
            );
          },
        );
      },
    );
  }

  Widget _buildEmailConfirmationTile(BuildContext context, bool isDarkMode) {
    return ListTile(
      title: Text(
        _isEmailVerified ? 'E-mail Confirmado' : 'Confirmar E-mail',
        style: TextStyle(
          color: _isEmailVerified
              ? Colors.green
              : (isDarkMode ? Colors.grey[400] : Colors.grey[800]),
        ),
      ),
      leading: Icon(
        Icons.email,
        color: _isEmailVerified ? Colors.green : Colors.blue,
      ),
      onTap: () async {
        if (!_isEmailVerified) {
          String? email = await _authService.getCurrentUserEmail();
          if (email == null) {
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Não foi possível obter o e-mail do usuário.')),
            );
            return;
          }
          if (!context.mounted) return;
          _showEmailDialog(context, email);
        }
      },
    );
  }

  Widget _buildPhoneVerificationTile(BuildContext context, bool isDarkMode) {
    return ListTile(
      title: Text(
        _isPhoneVerified ? 'Telefone Confirmado' : 'Confirmar Telefone',
        style: TextStyle(
          color: _isPhoneVerified
              ? Colors.green
              : (isDarkMode ? Colors.grey[400] : Colors.grey[800]),
        ),
      ),
      leading: Icon(
        Icons.phone,
        color: _isPhoneVerified ? Colors.green : Colors.blue,
      ),
      onTap: () async {
        String? phone = await _authService.getCurrentUserPhone();
        if (phone == null) {
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    'Não foi possível obter o número de telefone do usuário.')),
          );
          return;
        }
        if (kDebugMode) {
          print('Número de telefone do usuário: $phone');
        }
        if (!context.mounted) return;
        _showPhoneVerificationDialog(context, phone);
      },
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

  void _showEmailDialog(BuildContext context, String email) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar E-mail'),
          content: const Text(
            'Toque em Enviar para receber o código e verificar seu E-mail',
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
                await _authService.sendEmailVerification();
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('O código de verificação foi enviado.')),
                );
                await _checkEmailVerificationStatus();
              },
            ),
          ],
        );
      },
    );
  }

  void _showPhoneVerificationDialog(BuildContext context, String phone) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirme seu Telefone'),
          content: const Text(
            'Toque em Enviar para receber o código e verificar seu telefone.',
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
                await _authService.sendVerificationCode(phone);
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('O código de verificação foi enviado.')),
                );
                await _checkPhoneVerificationStatus();
              },
            ),
          ],
        );
      },
    );
  }
}
