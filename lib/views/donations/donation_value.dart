import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class DonationValue extends StatefulWidget {
  const DonationValue(
      {super.key,
      required this.donationController,
      required TextEditingController controller,
      required void Function(String value) onValueChanged});

  final TextEditingController donationController;

  @override
  State<DonationValue> createState() => _DonationValueState();
}

class _DonationValueState extends State<DonationValue> {
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
            controller: widget.donationController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              CurrencyInputFormatter(),
            ],
            decoration: const InputDecoration(
              hintText: 'Digite o valor da sua doação',
            ),
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
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    double value = double.parse(newValue.text);
    final formatter = NumberFormat.currency(locale: 'pt_BR', symbol: '€');
    String newText = formatter.format(value / 100);

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
