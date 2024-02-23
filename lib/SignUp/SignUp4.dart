import 'package:flutter/material.dart';
import 'package:churchapp/UserProfile.dart';

class SignUpPage4 extends StatefulWidget {
  const SignUpPage4({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignUpPage4State createState() => _SignUpPage4State();
}

class _SignUpPage4State extends State<SignUpPage4> {
  String password = '';
  String confirmPassword = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SignUp'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              obscureText: true,
              onChanged: (value) {
                setState(() {
                  password = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              obscureText: true,
              onChanged: (value) {
                setState(() {
                  confirmPassword = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Confirm Password',
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (password == confirmPassword) {
                        // Senhas coincidem, navegar para a página Home
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserProfile()),
                        );
                      } else {
                        // Senhas não coincidem, exibir mensagem de erro
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Passwords do not match!'),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: const Color.fromARGB(255, 90, 175, 249),
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: const Text('Next'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
