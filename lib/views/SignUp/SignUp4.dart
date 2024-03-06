// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:churchapp/views/user_profile.dart';
import 'package:flutter/material.dart';

class SignUp4 extends StatefulWidget {
  const SignUp4({Key? key}) : super(key: key);

  @override
  _SignUp4State createState() => _SignUp4State();
}

class _SignUp4State extends State<SignUp4> {
  get password => null;

  Object? get confirmPassword => null;

  // Remaining code for SignUpPage4...

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
                  // Update password state variable...
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
                  // Update confirmPassword state variable...
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
                        // Passwords match, navigate to the next page
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const UserProfile()),
                        );
                      } else {
                        // Passwords don't match, display error message
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Passwords do not match!'),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 90, 175, 249),
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
