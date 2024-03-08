// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:flutter/material.dart';

import 'SignUp3.dart';

class SignUpPage2 extends StatefulWidget {
  const SignUpPage2({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUpPage2> {
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
                const Row(
                  // Use Row instead of Column
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Day',
                        ),
                      ),
                    ),
                    SizedBox(width: 20.0), // Add spacing between widgets
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Month',
                        ),
                      ),
                    ),
                    SizedBox(width: 20.0), // Add spacing between widgets
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Year',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'Slect Gender',
                  ),
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
