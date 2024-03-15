import 'package:flutter/material.dart';
import 'sign_up_email_confirmation.dart';

class SignUpDateOfBirth extends StatefulWidget {
  const SignUpDateOfBirth({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignUpDateOfBirthState createState() => _SignUpDateOfBirthState();
}

class _SignUpDateOfBirthState extends State<SignUpDateOfBirth> {
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
                DateOfBirthDropdowns(
                  selectedDay: selectedDay,
                  selectedMonth: selectedMonth,
                  selectedYear: selectedYear,
                  onChangedDay: (value) {
                    setState(() {
                      selectedDay = value;
                    });
                  },
                  onChangedMonth: (value) {
                    setState(() {
                      selectedMonth = value;
                    });
                  },
                  onChangedYear: (value) {
                    setState(() {
                      selectedYear = value;
                    });
                  },
                ),
                const SizedBox(height: 20.0),
                GenderDropdown(
                  selectedGender: selectedGender,
                  onChangedGender: (value) {
                    setState(() {
                      selectedGender = value!;
                    });
                  },
                ),
                const SizedBox(height: 20.0),
                ElevatedButtonWidget(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const SignUpEmailConfirmation()),
                    );
                  },
                  text: 'Next',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DateOfBirthDropdowns extends StatelessWidget {
  const DateOfBirthDropdowns({
    super.key,
    this.selectedDay,
    this.selectedMonth,
    this.selectedYear,
    required this.onChangedDay,
    required this.onChangedMonth,
    required this.onChangedYear,
  });

  final int? selectedDay;
  final int? selectedMonth;
  final int? selectedYear;
  final ValueChanged<int?> onChangedDay;
  final ValueChanged<int?> onChangedMonth;
  final ValueChanged<int?> onChangedYear;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: DropdownButtonFormField<int>(
            decoration: const InputDecoration(
              labelText: 'Day',
            ),
            value: selectedDay,
            onChanged: onChangedDay,
            items: List.generate(31, (index) {
              return DropdownMenuItem<int>(
                value: index + 1,
                child: Text((index + 1).toString()),
              );
            }),
          ),
        ),
        const SizedBox(width: 20.0),
        Expanded(
          child: DropdownButtonFormField<int>(
            decoration: const InputDecoration(
              labelText: 'Month',
            ),
            value: selectedMonth,
            onChanged: onChangedMonth,
            items: List.generate(12, (index) {
              return DropdownMenuItem<int>(
                value: index + 1,
                child: Text((index + 1).toString()),
              );
            }),
          ),
        ),
        const SizedBox(width: 20.0),
        Expanded(
          child: DropdownButtonFormField<int>(
            decoration: const InputDecoration(
              labelText: 'Year',
            ),
            value: selectedYear,
            onChanged: onChangedYear,
            items: List.generate(80, (index) {
              return DropdownMenuItem<int>(
                value: DateTime.now().year - index,
                child: Text((DateTime.now().year - index).toString()),
              );
            }),
          ),
        ),
      ],
    );
  }
}

class GenderDropdown extends StatelessWidget {
  const GenderDropdown({
    super.key,
    required this.selectedGender,
    required this.onChangedGender,
  });

  final String selectedGender;
  final ValueChanged<String?> onChangedGender;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: 'Select Gender',
      ),
      value: selectedGender,
      onChanged: onChangedGender,
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
    );
  }
}

class ElevatedButtonWidget extends StatelessWidget {
  const ElevatedButtonWidget({
    super.key,
    required this.onPressed,
    required this.text,
  });

  final VoidCallback onPressed;
  final String text;

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
      child: Text(text),
    );
  }
}
