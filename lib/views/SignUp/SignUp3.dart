import 'package:flutter/material.dart';
import 'package:churchapp/views/signUp/signUp4.dart';

class SignUp3 extends StatefulWidget {
  const SignUp3({Key? key}) : super(key: key);

  @override
  _SignUpState3 createState() => _SignUpState3();
}

class _SignUpState3 extends State<SignUp3> {
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
                              builder: (context) => const SignUp4()),
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
    Key? key,
    required this.controller,
  }) : super(key: key);

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
    Key? key,
    required this.controller,
  }) : super(key: key);

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

class NextButton extends StatelessWidget {
  const NextButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 90, 175, 249),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      child: const Text('Next'),
    );
  }
}
