// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:churchapp/views/signUp/signUp3.dart';
import 'package:flutter/material.dart';

class SignUpPage2 extends StatefulWidget {
  const SignUpPage2({Key? key}) : super(key: key);

  @override
  _SignUpState2 createState() => _SignUpState2();
}

class _SignUpState2 extends State<SignUpPage2> {
  // Remaining code for SignUpPage2...

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
                // Date of Birth Section
                const Row(
                  children: [
                    // Remaining code for date of birth dropdowns...
                  ],
                ),
                const SizedBox(height: 20.0),
                // Gender Dropdown
                const Row(
                  children: [
                    // Remaining code for gender dropdown...
                  ],
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignUp3()),
                    );
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
