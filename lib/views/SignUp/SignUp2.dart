// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:churchapp/views/SignUp/signUp3.dart';

class SignUpPage2 extends StatefulWidget {
  const SignUpPage2({super.key});

  @override
  _SignUpPageState2 createState() => _SignUpPageState2();
}

class _SignUpPageState2 extends State<SignUpPage2> {
  String selectedDay = '1'; // Default selected day
  String selectedMonth = 'January'; // Default selected month
  int selectedYear = 2000; // Default selected year
  String selectedGender = ''; // Default selected gender

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
                const SizedBox(height: 200.0), // Adjusted SizedBox height

                // Date of Birth Section
                Row(
                  children: [
                    // Day Dropdown
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedDay,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedDay = newValue!;
                          });
                        },
                        items:
                            List.generate(31, (index) => (index + 1).toString())
                                .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        decoration: const InputDecoration(
                          labelText: 'Day',
                        ),
                      ),
                    ),

                    const SizedBox(
                      width: 20.0,
                    ),

                    // Month Dropdown
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedMonth,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedMonth = newValue!;
                          });
                        },
                        items: <String>[
                          'January',
                          'February',
                          'March',
                          'April',
                          'May',
                          'June',
                          'July',
                          'August',
                          'September',
                          'October',
                          'November',
                          'December'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        decoration: const InputDecoration(
                          labelText: 'Month',
                        ),
                      ),
                    ),

                    const SizedBox(
                      width: 20.0,
                    ),

                    // Year Dropdown
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        value: selectedYear,
                        onChanged: (int? newValue) {
                          setState(() {
                            selectedYear = newValue!;
                          });
                        },
                        items: List.generate(82, (index) => 1940 + index)
                            .map<DropdownMenuItem<int>>((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text(value.toString()),
                          );
                        }).toList(),
                        decoration: const InputDecoration(
                          labelText: 'Year',
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20.0),

                // Gender Dropdown
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedGender,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedGender = newValue!;
                          });
                        },
                        items: <String>['', 'Male', 'Female']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        decoration: const InputDecoration(
                          labelText: 'Gender',
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20.0),

                // Button "Next"
                ElevatedButton(
                  onPressed: () {
                    // Implement signup logic here
                    // Navigate to SignUp3 screen after signup
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpPage3()),
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
