import 'package:churchapp/services/auth_service.dart';
import 'package:churchapp/views/Member/firestore_service.dart';
import 'package:churchapp/views/nav_bar/nav_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BecomeMember extends StatefulWidget {
  const BecomeMember({super.key});

  @override
  State<BecomeMember> createState() => _BecomeMemberState();
}

class _BecomeMemberState extends State<BecomeMember> {
  late TextEditingController _phoneNumberController;
  late TextEditingController _addressController;
  late TextEditingController _lastVisitedChurchController;
  late TextEditingController _reasonForMembershipController;
  late TextEditingController _referenceController;
  late TextEditingController _fullNameController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  String selectedDDD = '+1';
  int numberOfPhoneDigits = 10;
  int? selectedDay;
  int? selectedMonth;
  int? selectedYear;
  String selectedGender = 'Male';
  String selectedCivilStatus = 'Single';

  final List<DDDCountryItem> dddCountryList = [
    DDDCountryItem(countryCode: 'US', dddCode: '+1', numberOfDigits: 10),
    DDDCountryItem(countryCode: 'FR', dddCode: '+33', numberOfDigits: 9),
    DDDCountryItem(countryCode: 'ES', dddCode: '+34', numberOfDigits: 9),
    DDDCountryItem(countryCode: 'IT', dddCode: '+39', numberOfDigits: 10),
    DDDCountryItem(countryCode: 'UK', dddCode: '+44', numberOfDigits: 11),
    DDDCountryItem(countryCode: 'DE', dddCode: '+49', numberOfDigits: 11),
    DDDCountryItem(countryCode: 'BR', dddCode: '+55', numberOfDigits: 11),
    DDDCountryItem(countryCode: 'PT', dddCode: '+351', numberOfDigits: 9),
    DDDCountryItem(countryCode: 'LU', dddCode: '+352', numberOfDigits: 9),
  ];

  @override
  void initState() {
    super.initState();
    _phoneNumberController = TextEditingController();
    _addressController = TextEditingController();
    _lastVisitedChurchController = TextEditingController();
    _reasonForMembershipController = TextEditingController();
    _referenceController = TextEditingController();
    _fullNameController = TextEditingController();
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    _addressController.dispose();
    _lastVisitedChurchController.dispose();
    _reasonForMembershipController.dispose();
    _referenceController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color buttonColor =
        theme.brightness == Brightness.light ? Colors.blue : Colors.grey;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Become a Member'),
        backgroundColor:
            theme.brightness == Brightness.light ? Colors.blue : Colors.grey,
      ),
      drawer: NavBar(
        auth: AuthenticationService(),
        authService: AuthenticationService(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildDateOfBirthSection(),
                const SizedBox(height: 20.0),
                _buildFullNameSection(),
                const SizedBox(height: 20.0),
                _buildPhoneNumberSection(),
                const SizedBox(height: 20.0),
                _buildLastVisitedChurchSection(),
                const SizedBox(height: 20.0),
                _buildCivilStatusSection(),
                const SizedBox(height: 20.0),
                _buildAdressSection(),
                const SizedBox(height: 20.0),
                _buildReasonForMembershipSection(),
                const SizedBox(height: 20.0),
                _buildReferenceSection(),
                const SizedBox(height: 20.0),
                _buildSignUpButton(buttonColor),
              ],
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
          child: _buildCountryCodeDropdown(),
        ),
        const SizedBox(width: 20.0),
        Expanded(
          flex: 3,
          child: _buildPhoneTextField(),
        ),
      ],
    );
  }

  Widget _buildCountryCodeDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedDDD,
      onChanged: (String? value) {
        setState(() {
          selectedDDD = value!;
          numberOfPhoneDigits = dddCountryList
              .firstWhere((item) => item.dddCode == selectedDDD)
              .numberOfDigits;
        });
      },
      items: dddCountryList
          .map((item) => DropdownMenuItem<String>(
                value: item.dddCode,
                child: Text(item.dddCode),
              ))
          .toList(),
      decoration: const InputDecoration(
        labelText: 'Country Code',
      ),
    );
  }

  Widget _buildPhoneTextField() {
    return Padding(
      padding: const EdgeInsets.only(top: 23.0),
      child: TextFormField(
        maxLength: numberOfPhoneDigits,
        controller: _phoneNumberController,
        keyboardType: TextInputType.phone,
        decoration: const InputDecoration(
          labelText: 'Phone Number',
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Phone number cannot be empty';
          }
          // Additional validation logic can be added here
          return null;
        },
      ),
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

  Widget _buildFullNameSection() {
    return TextFormField(
      controller: _fullNameController,
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
        labelText: 'Full Name',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Full name cannot be empty';
        }
        // Additional validation logic can be added aqui
        return null;
      },
    );
  }

  Widget _buildAdressSection() {
    return TextFormField(
      controller: _addressController,
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
        labelText: 'Address',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Address cannot be empty';
        }
        // Additional validation logic can be added aqui
        return null;
      },
    );
  }

  Widget _buildLastVisitedChurchSection() {
    return TextFormField(
      controller: _lastVisitedChurchController,
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
        labelText: 'Last Visited Church',
      ),
    );
  }

  Widget _buildCivilStatusSection() {
    return DropdownButtonFormField<String>(
      value: selectedCivilStatus,
      onChanged: (String? value) {
        setState(() {
          selectedCivilStatus = value!;
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
    return TextFormField(
      controller: _reasonForMembershipController,
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
        labelText: 'Reason for Membership',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Reason for membership cannot be empty';
        }
        // Additional validation logic can be added aqui
        return null;
      },
    );
  }

  Widget _buildReferenceSection() {
    return TextFormField(
      controller: _referenceController,
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
        labelText: 'Reference from Current Member',
      ),
    );
  }

  Widget _buildSignUpButton(Color buttonColor) {
    return ElevatedButton(
      onPressed: _isLoading ? null : _validateAndSubmit,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: buttonColor, // Change button color based on theme
      ),
      child: const Text('Submit'),
    );
  }

  void _validateAndSubmit() async {
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      setState(() {
        _isLoading = true;
      });

      final phoneNumber = _phoneNumberController.text.trim();
      final address = _addressController.text.trim();
      final lastVisitedChurch = _lastVisitedChurchController.text.trim();
      final reasonForMembership = _reasonForMembershipController.text.trim();
      final reference = _referenceController.text.trim();
      final fullName = _fullNameController.text.trim();

      final member = Member(
        id: '', // This will be set by Firestore
        phoneNumber: phoneNumber,
        address: address,
        lastVisitedChurch: lastVisitedChurch,
        reasonForMembership: reasonForMembership,
        reference: reference,
        fullName: fullName,
      );

      final firestoreService = BecomeMmemberService();
      try {
        await firestoreService.addMember(member);

        // Clear the form and show success message
        form.reset();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Application submitted successfully')),
        );
      } catch (e) {
        if (kDebugMode) {
          print('Error submitting application: $e');
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to submit application')),
          );
        }
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}

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

class DateOfBirthDropdowns extends StatelessWidget {
  final int? selectedDay;
  final int? selectedMonth;
  final int? selectedYear;
  final ValueChanged<int?> onChangedDay;
  final ValueChanged<int?> onChangedMonth;
  final ValueChanged<int?> onChangedYear;
  final bool canReturn = false;

  const DateOfBirthDropdowns({
    super.key,
    required this.selectedDay,
    required this.selectedMonth,
    required this.selectedYear,
    required this.onChangedDay,
    required this.onChangedMonth,
    required this.onChangedYear,
  });

  @override
  Widget build(BuildContext context) {
    // Implement your date of birth dropdowns here
    return Container();
  }
}

class GenderDropdown extends StatelessWidget {
  final String selectedGender;
  final ValueChanged<String?> onChangedGender;

  const GenderDropdown({
    super.key,
    required this.selectedGender,
    required this.onChangedGender,
  });

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

void main() {
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // Define your theme here
      ),
      home: const BecomeMember(),
    ),
  );
}
