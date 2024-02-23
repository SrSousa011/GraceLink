// ignore: file_names
import 'package:flutter/material.dart';
import 'package:churchapp/SignUp/SignUp4.dart';

class SignUpPage3 extends StatefulWidget {
  const SignUpPage3({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignUpPageState3 createState() => _SignUpPageState3();
}

class _SignUpPageState3 extends State<SignUpPage3> {
  String firstName = '';
  String lastName = '';
  String selectedEmailDomain = '@gmail.com'; // Default selected email domain

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

                // Row containing email text field and dropdown
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Email',
                        ),
                      ),
                    ),
                    const SizedBox(
                        width: 20.0), // Spacing between text field and dropdown
                    Expanded(
                      flex: 2,
                      child: DropdownButtonFormField<String>(
                        value: selectedEmailDomain,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedEmailDomain = newValue!;
                          });
                        },
                        items: <String>[
                          '@gmail.com',
                          '@outlook.com',
                          '@hotmail.com',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        decoration: const InputDecoration(
                          labelText: 'Domain',
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20.0),

                ElevatedButton(
                  onPressed: () {
                    // Implement signup logic here
                    // Navigate to SignUp4 screen after signup
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpPage4()),
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
