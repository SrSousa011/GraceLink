import 'package:churchapp/views/signUp/signUp_page.dart';
import 'package:churchapp/views/user_profile.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart'; // Importa a tela de SignUp

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void validateAndSubmit() {
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      if (kDebugMode) {
        print(
            'Form is valid. Email: $_emailController, Password: $_passwordController');
      }
      // Insira o código aqui para processar o login ou realizar outras ações após a validação do formulário.
    } else {
      if (kDebugMode) {
        print(
            'Form is invalid.  Email: $_emailController, Password: $_passwordController');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  TextFormField(
                    controller:
                        _emailController, // Atribua o TextEditingController ao controller
                    decoration: const InputDecoration(
                      labelText: 'Email',
                    ),
                    onSaved: (value) {
                      _emailController.text =
                          value!; // Salve o valor no TextEditingController
                    },
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    controller:
                        _passwordController, // Atribua o TextEditingController ao controller
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                    onSaved: (value) {
                      _passwordController.text =
                          value!; // Salve o valor no TextEditingController
                    },
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
                                builder: (context) => const SignInPage()),
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
