import 'package:flutter/material.dart';

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

// Reusable Widgets
class CountryCodeDropdown extends StatelessWidget {
  final String selectedDDD;
  final List<DropdownMenuItem<String>> dropdownItems;
  final ValueChanged<String?> onChanged;

  const CountryCodeDropdown({
    Key? key,
    required this.selectedDDD,
    required this.dropdownItems,
    required this.onChanged,
  }) : super(key: key);

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

class PhoneTextField extends StatelessWidget {
  final int maxLength;
  final TextEditingController controller;

  const PhoneTextField({
    Key? key,
    required this.maxLength,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Padding(
        padding: const EdgeInsets.only(top: 23.0),
        child: TextField(
          maxLength: maxLength,
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Phone',
          ),
        ),
      ),
    );
  }
}

// Main Widget
class BecomeMember extends StatefulWidget {
  const BecomeMember({Key? key}) : super(key: key);

  @override
  _BecomeMemberState createState() => _BecomeMemberState();
}

class _BecomeMemberState extends State<BecomeMember> {
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController churchController = TextEditingController();
  TextEditingController reasonController = TextEditingController();
  TextEditingController referenceController = TextEditingController();

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
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tornar-se Membro'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Address'),
              ),
              const SizedBox(height: 20.0),
              Row(
                children: [
                  CountryCodeDropdown(
                    selectedDDD: selectedDDD,
                    dropdownItems: buildDropdownItems(),
                    onChanged: (value) {
                      setState(() {
                        selectedDDD = value!;
                        numberOfPhoneDigits = dddCountryList
                            .firstWhere((item) => item.dddCode == selectedDDD)
                            .numberOfDigits;
                      });
                    },
                  ),
                  const SizedBox(width: 10.0),
                  PhoneTextField(
                    maxLength: numberOfPhoneDigits,
                    controller: phoneController,
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: churchController,
                decoration:
                    const InputDecoration(labelText: 'Last visited church?'),
              ),
              const SizedBox(height: 20.0),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Civil State',
                ),
                value: selectedCivilState,
                onChanged: (value) {
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
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: reasonController,
                decoration: const InputDecoration(
                  labelText: 'Why do you want to become a member?',
                ),
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: referenceController,
                decoration: const InputDecoration(
                  labelText: 'Reference from a current member',
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Confirmation'),
                        content: const Text(
                            'You have successfully become a member!'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Close'),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                ),
                child: const Text('Become a Member'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> buildDropdownItems() {
    return dddCountryList.map((item) {
      return DropdownMenuItem<String>(
        value: item.dddCode,
        child: Row(
          children: [
            const SizedBox(width: 10),
            Text(item.dddCode),
          ],
        ),
      );
    }).toList();
  }
}

void main() {
  runApp(const MaterialApp(
    home: BecomeMember(),
  ));
}
