import 'package:churchapp/views/signUp/sign_up_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    super.key,
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

  const PhoneTextField({
    super.key,
    required this.maxLength,
    required this.controller,
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

// BecomeMember Widget
class BecomeMember extends StatefulWidget {
  const BecomeMember({super.key});

  @override
  State<BecomeMember> createState() => _BecomeMemberState();
}

class _BecomeMemberState extends State<BecomeMember> {
  late TextEditingController _emailController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _addressController;
  late TextEditingController _lastVisitedChurchController;
  late TextEditingController _reasonForMembershipController;
  late TextEditingController _referenceController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final bool _isLoading = false;

  String selectedCivilState = 'Single';
  String selectedDDD = '+1';
  int numberOfPhoneDigits = 10;
  int? selectedDay;
  int? selectedMonth;
  int? selectedYear;
  String selectedGender = 'Male';

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
    DDDCountryItem(
      countryCode: 'ES',
      dddCode: '+34',
      numberOfDigits: 9,
    ),
    DDDCountryItem(
      countryCode: 'IT',
      dddCode: '+39',
      numberOfDigits: 10,
    ),
    DDDCountryItem(
      countryCode: 'UK',
      dddCode: '+44',
      numberOfDigits: 11,
    ),
    DDDCountryItem(
      countryCode: 'DE',
      dddCode: '+49',
      numberOfDigits: 11,
    ),
    DDDCountryItem(
      countryCode: 'BR',
      dddCode: '+55',
      numberOfDigits: 11,
    ),
    DDDCountryItem(
      countryCode: 'PT',
      dddCode: '+351',
      numberOfDigits: 9,
    ),
    DDDCountryItem(
      countryCode: 'LU',
      dddCode: '+352',
      numberOfDigits: 9,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _addressController = TextEditingController();
    _lastVisitedChurchController = TextEditingController();
    _reasonForMembershipController = TextEditingController();
    _referenceController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    _lastVisitedChurchController.dispose();
    _reasonForMembershipController.dispose();
    _referenceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Become a Member'),
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
                  _buildDateOfBirthSection(),
                  const SizedBox(height: 20.0),
                  _buildGenderSection(),
                  const SizedBox(height: 20.0),
                  _buildEmailSection(),
                  const SizedBox(height: 20.0),
                  _buildPhoneNumberSection(),
                  const SizedBox(height: 20.0),
                  _buildCountryCodeSection(),
                  const SizedBox(height: 20.0),
                  _buildLastVisitedChurchSection(),
                  const SizedBox(height: 20.0),
                  _buildCivilStatusSection(),
                  const SizedBox(height: 20.0),
                  _buildReasonForMembershipSection(),
                  const SizedBox(height: 20.0),
                  _buildReferenceSection(),
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

  Widget _buildCountryCodeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: TextEditingController(text: selectedDDD),
          readOnly: true,
          onTap: () {
            // Implement logic to navigate to a page where users can select a country code
          },
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
            labelText: 'Country Code',
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

  Widget _buildEmailSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'Email',
          ),
          validator: _validateEmail,
        ),
      ],
    );
  }

  Widget _buildLastVisitedChurchSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _lastVisitedChurchController,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
            labelText: 'Last Visited Church',
          ),
        ),
      ],
    );
  }

  Widget _buildCivilStatusSection() {
    return DropdownButtonFormField<String>(
      value: selectedCivilState,
      onChanged: (String? value) {
        setState(() {
          selectedCivilState = value!;
        });
      },
      items: const [
        DropdownMenuItem<String>(
          value: 'Single',
          child: Text('Single'),
        ),
        DropdownMenuItem<String>(
          value: 'Married',
          child: Text('Married'),
        ),
        DropdownMenuItem<String>(
          value: 'Divorced',
          child: Text('Divorced'),
        ),
      ],
      decoration: const InputDecoration(
        labelText: 'Civil Status',
      ),
    );
  }

  Widget _buildReasonForMembershipSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _reasonForMembershipController,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
            labelText: 'Reason for Membership',
          ),
        ),
      ],
    );
  }

  Widget _buildReferenceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _referenceController,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
            labelText: 'Reference from Current Member',
          ),
        ),
      ],
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
      child: const Text('Submit Application'),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email cannot be empty';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Invalid email address';
    }
    return null;
  }

  Future<void> _validateAndSubmit() async {
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      // Form is valid, process sign up here.
      String phoneNumber = _phoneNumberController.text.trim();
      String address = _addressController.text.trim();
      String countryCode = selectedDDD; // Use selectedDDD for country code
      String lastVisitedChurch = _lastVisitedChurchController.text.trim();
      String civilStatus = selectedCivilState;
      String reasonForMembership = _reasonForMembershipController.text.trim();
      String reference = _referenceController.text.trim();

      try {
        // Find the DDD item for the selected country code
        dddCountryList.firstWhere(
          (item) => item.dddCode == selectedDDD,
          orElse: () => DDDCountryItem(
            countryCode: '',
            dddCode: selectedDDD,
            numberOfDigits: 10, // Default to 10 digits if not found
          ),
        );

        // Example: Implement the logic to send this data to the server or process it
        // Here, we're just printing it for demonstration purposes
        if (kDebugMode) {
          print('Phone Number: $phoneNumber');
          print('Address: $address');
          print('Country Code: $countryCode');
          print('Last Visited Church: $lastVisitedChurch');
          print('Civil Status: $civilStatus');
          print('Reason for Membership: $reasonForMembership');
          print('Reference: $reference');
        }

        if (mounted) {
          // Replace this with your navigation logic
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error: $e');
        }
      }
    }
  }
}

void main() {
  runApp(
    MultiProvider(
      providers: const [
        // Add your provider for CountryCodeService here if needed
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const BecomeMember(),
      ),
    ),
  );
}
