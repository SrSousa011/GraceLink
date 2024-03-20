import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _confirmEmailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  int? selectedDay;
  int? selectedMonth;
  int? selectedYear;
  String selectedGender = 'Male';

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _confirmEmailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _confirmEmailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

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
                const SizedBox(height: 20.0),
                TextFieldWidget(
                  labelText: 'First Name',
                  controller: _firstNameController,
                ),
                const SizedBox(height: 20.0),
                TextFieldWidget(
                  labelText: 'Last Name',
                  controller: _lastNameController,
                ),
                const SizedBox(height: 20.0),
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
                TextFieldWidget(
                  labelText: 'Email',
                  controller: _emailController,
                ),
                const SizedBox(height: 20.0),
                TextFieldWidget(
                  labelText: 'Confirm Email',
                  controller: _confirmEmailController,
                ),
                const SizedBox(height: 20.0),
                TextFieldWidget(
                  labelText: 'Password',
                  controller: _passwordController,
                ),
                const SizedBox(height: 20.0),
                TextFieldWidget(
                  labelText: 'Confirm Password',
                  controller: _confirmPasswordController,
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    // Validate fields and navigate to next step
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

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({
    super.key,
    required this.labelText,
    required this.controller,
  });

  final String labelText;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
      ),
    );
  }
}
