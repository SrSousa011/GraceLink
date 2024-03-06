// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:churchapp/views/signUp/signUp.dart';
import 'package:churchapp/views/user_profile.dart';
import 'package:flutter/material.dart'; // Importa a tela de SignUp

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key); // Adding a key to the login widget

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // GlobalKey

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        // Center widget added here
        child: SingleChildScrollView(
          // SingleChildScrollView wrapped around the content
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey, // Assigning the GlobalKey to the Form widget
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const TextField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  const TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Navigate para a tela de UserProfile
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const UserProfile()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: const Color(0xFF1E88E5),
                          backgroundColor: Colors.white, // Cor do texto azul
                          side: const BorderSide(
                              color: Color(0xFF1E88E5)), // Borda azul
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        child: const Text('Login'),
                      ),
                      const SizedBox(width: 20), // Espaçamento entre os botões
                      ElevatedButton(
                        onPressed: () {
                          // Navigate para a tela de SignUp
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUp()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color.fromARGB(
                              255, 90, 175, 249), // Cor do texto branco
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        child: const Text('Sign Up'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
