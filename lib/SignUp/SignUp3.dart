import 'package:flutter/material.dart';
import 'package:churchapp/SignUp/SignUp4.dart';

class SignUpPage3 extends StatefulWidget {
  @override
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
        title: Text('SignUp'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: 200.0),

                // Row containing email text field and dropdown
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Email',
                        ),
                      ),
                    ),
                    SizedBox(
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
                        decoration: InputDecoration(
                          labelText: 'Domain',
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20.0),

                ElevatedButton(
                  onPressed: () {
                    // Implement signup logic here
                    // Navigate to SignUp4 screen after signup
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpPage4()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 90, 175, 249),
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: Text('Next'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
