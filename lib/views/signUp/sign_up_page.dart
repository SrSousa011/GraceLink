import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:churchapp/services/auth_method.dart'; // Adjust import path based on your project structure
import 'package:churchapp/services/auth_service.dart'; // Adjust import path based on your project structure
import 'package:churchapp/views/home/home.dart'; // Adjust import path based on your project structure
import 'package:churchapp/views/signUp/date_birth.dart'; // Adjust import path based on your project structure
import 'package:churchapp/views/signUp/gender.dart'; // Adjust import path based on your project structure
import 'package:churchapp/views/signUp/phone.dart'; // Adjust import path based on your project structure
import 'package:churchapp/views/signUp/telephoneNumber.dart'; // Adjust import path based on your project structure
import 'package:churchapp/views/signUp/text_field.dart'; // Adjust import path based on your project structure

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key, required this.auth, required this.onSignedIn});
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

  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isPasswordConfVisible = false;
  final AuthMethods _authMethods = AuthMethods();

  int? selectedDay;
  int? selectedMonth;
  int? selectedYear;
  String selectedGender = 'Male';
  String selectedCivilState = 'Single';
  String selectedDDD = '+1';
  int numberOfPhoneDigits = 10;

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
          validator: _authMethods.validateFirstName,
        ),
        const SizedBox(height: 20.0),
        TextFieldWidget(
          labelText: 'Last Name',
          controller: _lastNameController,
          validator: _authMethods.validateLastName,
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
            validator: _authMethods.validatePhoneNumber,
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
          validator: _authMethods.validateEmail,
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
          validator: _authMethods.validatePassword,
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

  String? _validateEmailConf(String? value) {
    final String email = _emailController.text.trim();
    if (value != email) {
      return 'Emails do not match';
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
        setState(() {
          _isLoading = true;
        });

        // Create user in Firebase Authentication
        UserCredential userCredential =
            await widget.auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Save user data to Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'fullName':
              _firstNameController.text + _lastNameController.text.trim(),
          'email': email,
          'phoneNumber': selectedDDD + _phoneNumberController.text.trim(),
          'dateOfBirth': DateTime(
            selectedYear!,
            selectedMonth!,
            selectedDay!,
          ),
        });

        setState(() {
          _isLoading = false;
        });

        widget
            .onSignedIn(); // Calling the onSignedIn method to indicate that the user is signed in

        if (kDebugMode) {
          print('User created: ${userCredential.user!.uid}');
        }

        if (mounted) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => Home(
              auth: widget.auth,
              userId: userCredential.user!.uid,
              onSignedOut: () {
                // Implement logout if needed
              },
            ),
          ));
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error: $e');
        }
        if (!mounted) return;
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Sign Up Error'),
              content: Text('Failed to sign up: $e'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }
}
