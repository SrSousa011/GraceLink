import 'package:flutter/material.dart';
import 'SignUp3.dart';

class SignUpPage2 extends StatefulWidget {
  const SignUpPage2({Key? key}) : super(key: key);

  @override
  _SignUpPage2State createState() => _SignUpPage2State();
}

class _SignUpPage2State extends State<SignUpPage2> {
  int? selectedDay;
  int? selectedMonth;
  int? selectedYear;
  String selectedGender = 'Male'; // Set an initial value

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
                Row(
                  children: <Widget>[
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        decoration: const InputDecoration(
                          labelText: 'Day',
                        ),
                        value: selectedDay,
                        onChanged: (value) {
                          setState(() {
                            selectedDay = value!;
                          });
                        },
                        items: List.generate(31, (index) {
                          return DropdownMenuItem<int>(
                            value: index + 1,
                            child: Text((index + 1).toString()),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(width: 20.0), // Add spacing between widgets
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        decoration: const InputDecoration(
                          labelText: 'Month',
                        ),
                        value: selectedMonth,
                        onChanged: (value) {
                          setState(() {
                            selectedMonth = value!;
                          });
                        },
                        items: List.generate(12, (index) {
                          return DropdownMenuItem<int>(
                            value: index + 1,
                            child: Text((index + 1).toString()),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(width: 20.0), // Add spacing between widgets
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        decoration: const InputDecoration(
                          labelText: 'Year',
                        ),
                        value: selectedYear,
                        onChanged: (value) {
                          setState(() {
                            selectedYear = value!;
                          });
                        },
                        items: List.generate(80, (index) {
                          return DropdownMenuItem<int>(
                            value: DateTime.now().year - index,
                            child:
                                Text((DateTime.now().year - index).toString()),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Select Gender',
                  ),
                  value: selectedGender,
                  onChanged: (value) {
                    setState(() {
                      selectedGender = value!;
                    });
                  },
                  items: const [
                    DropdownMenuItem<String>(
                      value: 'Male',
                      child: Text('Male'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'Female',
                      child: Text('Female'),
                    ),
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
