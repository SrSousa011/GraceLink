import 'package:flutter/material.dart';

class DonationHow extends StatefulWidget {
  const DonationHow({
    Key? key,
    required String selectedPayment,
    required Null Function(dynamic payment) onPaymentSelected,
    required Null Function(dynamic type) onTypeSelected,
  }) : super(key: key);

  @override
  State<DonationHow> createState() => _DonationHowState();
}

class _DonationHowState extends State<DonationHow> {
  late String selectedPayment; // Declare selectedPayment variable

  @override
  void initState() {
    super.initState();
    selectedPayment = 'Paypal'; // Initialize selectedPayment
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Método de Pagamento:',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 153, 153, 153),
            ),
          ),
          const SizedBox(height: 10.0),
          DropdownButtonFormField<String>(
            value: selectedPayment,
            onChanged: (String? newValue) {
              setState(() {
                selectedPayment = newValue!;
              });
            },
            items: <String>['Paypal', 'Cartão de Crédito', 'Cartão de Débito']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }
}
