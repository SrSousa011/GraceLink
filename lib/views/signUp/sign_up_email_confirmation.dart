import 'package:flutter/material.dart';
import 'package:churchapp/views/signUp/sign_up_password_creation.dart';

class SignUpEmailConfirmation extends StatefulWidget {
  const SignUpEmailConfirmation({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignUpEmailConfirmation createState() => _SignUpEmailConfirmation();
}

class _SignUpEmailConfirmation extends State<SignUpEmailConfirmation> {
  TextEditingController emailController = TextEditingController();
  TextEditingController confirmEmailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SignUp'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 200.0),
                EmailTextField(controller: emailController),
                const SizedBox(height: 20.0),
                ConfirmEmailTextField(controller: confirmEmailController),
                const SizedBox(height: 20.0),
                NextButton(
                  onPressed: () {
                    // Check if the email and confirm email fields are not empty
                    if (emailController.text.isNotEmpty &&
                        confirmEmailController.text.isNotEmpty) {
                      // Check if the email and confirm email fields match
                      if (emailController.text == confirmEmailController.text) {
                        // Navigate to the next step in the signup process
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const SignUpPasswordCreation()),
                        );
                      } else {
                        // Display a dialog indicating email mismatch
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Error'),
                              content: const Text('Emails do not match.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    } else {
                      // Display a dialog indicating empty fields
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Error'),
                            content: const Text('Please fill in all fields.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EmailTextField extends StatelessWidget {
  const EmailTextField({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Email',
            ),
          ),
        ),
      ],
    );
  }
}

class ConfirmEmailTextField extends StatelessWidget {
  const ConfirmEmailTextField({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Confirm Email',
            ),
          ),
        ),
      ],
    );
  }
}
