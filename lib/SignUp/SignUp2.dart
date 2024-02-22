import 'package:churchapp/Home.dart';
import 'package:churchapp/SignUp/SignUp3.dart';
import 'package:flutter/material.dart';

class SignUpPage2 extends StatefulWidget {
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
                SizedBox(height: 200.0), // Adjusted SizedBox height

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
                        decoration: InputDecoration(
                          labelText: 'Day',
                        ),
                      ),
                    ),

                    SizedBox(
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
                        decoration: InputDecoration(
                          labelText: 'Month',
                        ),
                      ),
                    ),

                    SizedBox(
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
                        decoration: InputDecoration(
                          labelText: 'Year',
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),

                // Gender Dropdown
                DropdownButtonFormField<String>(
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
                  decoration: InputDecoration(
                    labelText: 'Gender',
                  ),
                ),

                SizedBox(height: 20.0),

                // Button "Next"
                ElevatedButton(
                  onPressed: () {
                    // Implement signup logic here
                    // Navigate to SignUp3 screen after signup
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpPage3()),
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
