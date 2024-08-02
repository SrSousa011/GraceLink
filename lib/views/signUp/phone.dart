import 'package:flutter/material.dart';

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
