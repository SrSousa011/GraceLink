import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:churchapp/auth/auth_method.dart';
import 'package:churchapp/auth/auth_service.dart';
import 'package:churchapp/views/home/home.dart';
import 'package:churchapp/views/signUp/date_birth.dart';
import 'package:churchapp/views/signUp/gender.dart';
import 'package:churchapp/views/signUp/phone.dart';
import 'package:churchapp/views/signUp/telephone_number.dart';

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
  late TextEditingController _cityController;
  late TextEditingController _countryController;
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
    _cityController = TextEditingController();
    _countryController = TextEditingController();
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
    _cityController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Registrar-se',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
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
                  _buildPhoneNumberSection(),
                  const SizedBox(height: 20.0),
                  _buildGenderSection(),
                  const SizedBox(height: 20.0),
                  _buildCityAndCountry(),
                  const SizedBox(height: 20.0),
                  _buildEmailSection(),
                  const SizedBox(height: 20.0),
                  _buildPasswordSection(),
                  const SizedBox(height: 20.0),
                  _buildPasswordSectionConfirmation(),
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
        _buildTextField(
          labelText: 'First Name',
          controller: _firstNameController,
          validator: _authMethods.validateFirstName,
        ),
        const SizedBox(height: 20.0),
        _buildTextField(
          labelText: 'Last Name',
          controller: _lastNameController,
          validator: _authMethods.validateLastName,
        ),
      ],
    );
  }

  Widget _buildCityAndCountry() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(
          labelText: 'City',
          controller: _cityController,
          validator: _authMethods.validateCity,
        ),
        const SizedBox(height: 20.0),
        _buildTextField(
          labelText: 'Country',
          controller: _countryController,
          validator: _authMethods.validateCountry,
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
        _buildTextField(
          labelText: 'Email',
          controller: _emailController,
          validator: _authMethods.validateEmail,
        ),
        const SizedBox(height: 20.0),
        _buildTextField(
          labelText: 'Confirm Email',
          controller: _confirmEmailController,
          validator: _validateEmailConf,
        ),
      ],
    );
  }

  Widget _buildPasswordSection() {
    return _buildPasswordField(
      controller: _passwordController,
      obscureText: !_isPasswordConfVisible,
      labelText: 'Password',
      onVisibilityToggle: () {
        setState(() {
          _isPasswordConfVisible = !_isPasswordConfVisible;
        });
      },
      isPasswordVisible: _isPasswordConfVisible,
      validator: _authMethods.validatePassword,
    );
  }

  Widget _buildPasswordSectionConfirmation() {
    return _buildPasswordField(
      controller: _confirmPasswordController,
      obscureText: !_isPasswordVisible,
      labelText: 'Confirm Password',
      onVisibilityToggle: () {
        setState(() {
          _isPasswordVisible = !_isPasswordVisible;
        });
      },
      isPasswordVisible: _isPasswordVisible,
      validator: _validatePasswordConf,
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

  Widget _buildTextField({
    required String labelText,
    required TextEditingController controller,
    FormFieldValidator<String>? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: labelText),
      validator: validator,
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required bool obscureText,
    required String labelText,
    required VoidCallback onVisibilityToggle,
    required bool isPasswordVisible,
    required FormFieldValidator<String>? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        suffixIcon: IconButton(
          icon: Icon(
            isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: onVisibilityToggle,
        ),
      ),
      obscureText: obscureText,
      validator: validator,
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
    if (form!.validate()) {
      setState(() {
        _isLoading = true;
      });

      String email = _emailController.text.trim();
      String password = _passwordController.text;

      String? firstName = _firstNameController.text.trim();
      String? lastName = _lastNameController.text.trim();
      String? phoneNumber = _phoneNumberController.text.trim();
      String? city = _cityController.text.trim();
      String? country = _countryController.text.trim();

      DateTime? dateOfBirth;
      if (selectedYear != null &&
          selectedMonth != null &&
          selectedDay != null) {
        dateOfBirth = DateTime(
          selectedYear!,
          selectedMonth!,
          selectedDay!,
        );
      }

      try {
        UserCredential userCredential =
            await widget.auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'fullName': '$firstName $lastName',
          'email': email,
          'phoneNumber': selectedDDD + (phoneNumber),
          'address': '$city $country',
          'dateOfBirth': dateOfBirth,
        });

        setState(() {
          _isLoading = false;
        });

        widget.onSignedIn();

        if (kDebugMode) {
          print('User created: ${userCredential.user!.uid}');
        }

        if (mounted) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const Home(),
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
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  void showError(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Validation Error'),
          content: Text(message),
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
