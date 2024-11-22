import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class DonationValue extends StatefulWidget {
  const DonationValue({
    super.key,
    required this.value,
    required this.onValueChanged,
  });

  final double value;
  final void Function(double value) onValueChanged;

  @override
  State<DonationValue> createState() => _DonationValueState();
}

class _DonationValueState extends State<DonationValue> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: CurrencyInputFormatter().format(widget.value),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Valor da doação:',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 153, 153, 153),
            ),
          ),
          TextField(
            controller: _controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              CurrencyInputFormatter(),
            ],
            decoration: const InputDecoration(
              hintText: 'Digite o valor da sua doação',
            ),
            onChanged: (value) {
              try {
                final formattedValue = value.replaceAll(RegExp(r'[^\d]'), '');
                double valueInEuros = double.parse(formattedValue) / 100;

                widget.onValueChanged(valueInEuros);
              } catch (e) {
                if (kDebugMode) {
                  print('Error parsing value: $e');
                }
                widget.onValueChanged(0.0);
              }
            },
          ),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '', selection: newValue.selection);
    }

    final text = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    final value = double.parse(text) / 100;

    final formatter = NumberFormat.currency(locale: 'pt_BR', symbol: '€');
    final newText = formatter.format(value);

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }

  String format(double value) {
    final formatter = NumberFormat.currency(locale: 'pt_BR', symbol: '€');
    return formatter.format(value);
  }
}
