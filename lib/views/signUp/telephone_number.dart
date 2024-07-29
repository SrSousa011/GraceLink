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
