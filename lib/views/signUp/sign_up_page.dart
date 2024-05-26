import 'package:churchapp/services/auth_service.dart';
import 'package:churchapp/views/home/home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

// Model for the DDD Country Item
class DDDCountryItem {
  final String countryCode;
  final String dddCode;
  final int numberOfDigits;

  DDDCountryItem({
    required this.countryCode,
    required this.dddCode,
    required this.numberOfDigits,
  });
}

// Dropdown Widget for Country Code
class CountryCodeDropdown extends StatelessWidget {
  final String selectedDDD;
  final List<DropdownMenuItem<String>> dropdownItems;
  final ValueChanged<String?> onChanged;

  const CountryCodeDropdown({
    Key? key,
    required this.selectedDDD,
    required this.dropdownItems,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          labelText: 'Country Code',
        ),
        value: selectedDDD,
        onChanged: onChanged,
        items: dropdownItems,
      ),
    );
  }
}

// Phone Text Field Widget
class PhoneTextField extends StatelessWidget {
  final int maxLength;
  final TextEditingController controller;
  final String? Function(String value) validator;

  const PhoneTextField({
    Key? key,
    required this.maxLength,
    required this.controller,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Padding(
        padding: const EdgeInsets.only(top: 23.0),
        child: TextField(
          maxLength: maxLength,
          controller: controller,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: 'Phone Number',
          ),
        ),
      ),
    );
  }
}

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key, required this.auth, required this.onSignedIn});
  final BaseAuth auth;
  final VoidCallback onSignedIn;

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
  late TextEditingController _phoneNumberController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isPasswordConfVisible = false;

  int? selectedDay;
  int? selectedMonth;
  int? selectedYear;
  String selectedGender = 'Male'; // Initial gender selection

  String selectedCivilState = 'Single';
  String selectedDDD = '+1';
  int numberOfPhoneDigits = 10;

  List<DDDCountryItem> dddCountryList = [
    DDDCountryItem(
      countryCode: 'US',
      dddCode: '+1',
      numberOfDigits: 10,
    ),
    DDDCountryItem(
      countryCode: 'FR',
      dddCode: '+33',
      numberOfDigits: 9,
    ),
    // Other DDDCountryItem entries
  ];

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _confirmEmailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _phoneNumberController = TextEditingController();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _confirmEmailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildNameSection(),
                  const SizedBox(height: 20.0),
                  _buildDateOfBirthSection(),
                  const SizedBox(height: 20.0),
                  _buildGenderSection(),
                  const SizedBox(height: 20.0),
                  _buildEmailSection(),
                  const SizedBox(height: 20.0),
                  _buildPasswordSection(),
                  const SizedBox(height: 20.0),
                  _buildPasswordSectionConfirmation(),
                  const SizedBox(height: 20.0),
                  _buildPhoneNumberSection(),
                  const SizedBox(height: 20.0),
                  _buildSignUpButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNameSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldWidget(
          labelText: 'First Name',
          controller: _firstNameController,
          validator: _validateName,
        ),
        const SizedBox(height: 20.0),
        TextFieldWidget(
          labelText: 'Last Name',
          controller: _lastNameController,
          validator: _validateLastName,
        ),
      ],
    );
  }

  Widget _buildPhoneNumberSection() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: CountryCodeDropdown(
            selectedDDD: selectedDDD,
            dropdownItems: dddCountryList
                .map((item) => DropdownMenuItem<String>(
                      value: item.dddCode,
                      child: Text(item.dddCode),
                    ))
                .toList(),
            onChanged: (String? value) {
              setState(() {
                selectedDDD = value!;
                numberOfPhoneDigits = dddCountryList
                    .firstWhere((element) => element.dddCode == selectedDDD)
                    .numberOfDigits;
              });
            },
          ),
        ),
        const SizedBox(width: 20.0),
        Expanded(
          flex: 2,
          child: PhoneTextField(
            maxLength: numberOfPhoneDigits,
            controller: _phoneNumberController,
            validator: _validatePhoneNumber,
          ),
        ),
      ],
    );
  }

  Widget _buildDateOfBirthSection() {
    return DateOfBirthDropdowns(
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
    );
  }

  Widget _buildEmailSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldWidget(
          labelText: 'Email',
          controller: _emailController,
          validator: _validateEmail,
        ),
        const SizedBox(height: 20.0),
        TextFieldWidget(
          labelText: 'Confirm Email',
          controller: _confirmEmailController,
          validator: _validateEmailConf,
        ),
      ],
    );
  }

  Widget _buildPasswordSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _passwordController,
          decoration: InputDecoration(
            labelText: 'Password',
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordConfVisible
                    ? Icons.visibility
                    : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordConfVisible = !_isPasswordConfVisible;
                });
              },
            ),
          ),
          obscureText: !_isPasswordConfVisible,
          validator: _validatePassword,
        ),
      ],
    );
  }

  Widget _buildPasswordSectionConfirmation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _confirmPasswordController,
          decoration: InputDecoration(
            labelText: 'Confirm Password ',
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
          ),
          obscureText: !_isPasswordVisible,
          validator: _validatePasswordConf,
        ),
      ],
    );
  }

  Widget _buildGenderSection() {
    return GenderDropdown(
      selectedGender: selectedGender,
      onChangedGender: (value) {
        setState(() {
          selectedGender = value!;
        });
      },
    );
  }

  Widget _buildSignUpButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _validateAndSubmit,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 90, 175, 249),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      child: const Text('Sign Up'),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email cannot be empty';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Invalid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name cannot be empty';
    }
    return null;
  }

  String? _validateLastName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Last Name cannot be empty';
    }
    return null;
  }

  String? _validatePhoneNumber(String value) {
    if (value.isEmpty) {
      return 'Phone number cannot be empty';
    }
    return null;
  }

  String? _validateEmailConf(String? value) {
    final String email = _emailController.text.trim();
    if (value != email) {
      return 'Passwords do not match';
    }
    return null;
  }

  String? _validatePasswordConf(String? value) {
    final String passwordControllerValue = _passwordController.text.trim();
    if (value != passwordControllerValue) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> _validateAndSubmit() async {
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      // Form is valid, process sign up here.
      String email = _emailController.text.trim();
      String password = _passwordController.text;
      try {
        UserCredential userCredential =
            await widget.auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        widget
            .onSignedIn(); // Chamando o método onSignedIn para indicar que o usuário está logado
        if (kDebugMode) {
          print('User created: ${userCredential.user!.uid}');
        }
        if (mounted) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => Home(
              auth: widget.auth,
              userId: userCredential.user!.uid,
              onSignedOut: () {
                // Implemente o logout se necessário
              },
            ),
          ));
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error: $e');
        }
        // Handle sign-up errors, such as displaying an error message
      }
    }
  }
}

class DateOfBirthDropdowns extends StatelessWidget {
  const DateOfBirthDropdowns({
    super.key,
    this.selectedDay,
    this.selectedMonth,
    this.selectedYear,
    required this.onChangedDay,
    required this.onChangedMonth, // This field name should match the one provided here
    required this.onChangedYear,
  });

  final int? selectedDay;
  final int? selectedMonth;
  final int? selectedYear;
  final ValueChanged<int?> onChangedDay;
  final ValueChanged<int?>
      onChangedMonth; // Ensure this matches the field name provided
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
            onChanged:
                onChangedMonth, // Ensure this matches the field name provided
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
    this.validator,
    this.obscureText = false,
  });

  final String labelText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
      ),
      validator: validator,
      obscureText: obscureText,
    );
  }
}
