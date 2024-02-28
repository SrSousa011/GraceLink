import 'package:churchapp/views/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

void main() => runApp(const Donations());

class Donations extends StatelessWidget {
  const Donations({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: DonationsPage(),
    );
  }
}

class DonationsPage extends StatelessWidget {
  const DonationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donations'),
      ),
      drawer: const NavBar(),
      body: const DonationWidget(), // Incorporando o DonationWidget aqui
    );
  }
}

class DonationWidget extends StatefulWidget {
  const DonationWidget({Key? key}) : super(key: key);

  @override
  DonationWidgetState createState() => DonationWidgetState();
}

class DonationWidgetState extends State<DonationWidget> {
  TextEditingController donationController = TextEditingController();
  String? donationType;
  String? foodType;
  String selectedPayment = 'Paypal'; // Default selected payment

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
          Expanded(
            child: TextField(
              controller: donationController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                CurrencyInputFormatter()
              ],
              decoration: const InputDecoration(
                hintText: 'Digite o valor da sua doação',
              ),
            ),
          ),
          const SizedBox(height: 40.0),
          const Text(
            'Doar como:',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 153, 153, 153),
            ),
          ),
          const SizedBox(height: 10.0),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: selectedPayment,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedPayment = newValue!;
                    });
                  },
                  items: <String>[
                    'Paypal',
                    'Cartão de Crédito',
                    'Cartão de Débito'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    labelText: ' ',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40.0),
          const Text(
            'Destino da doação:',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 153, 153, 153),
            ),
          ),
          const SizedBox(height: 10.0),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    _navigateToChooseTypePage(context, 'chooseDonationType');
                  },
                  icon: const Icon(Icons.payment),
                  label: const Text('Escolha o tipo de doação'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(400, 100),
                    foregroundColor: const Color(0xFF1E88E5),
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 40.0),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    _navigateToChooseTypePage(context, 'chooseFoodType');
                  },
                  icon: const Icon(Icons.food_bank),
                  label: const Text('Selecione o tipo de alimento'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(400, 100),
                    foregroundColor: const Color(0xFF1E88E5),
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 70.0),
          if (donationType != null) Image.asset('assets/$donationType.png'),
          if (foodType != null) Image.asset('assets/$foodType.png'),
        ],
      ),
    );
  }

  void _navigateToChooseTypePage(BuildContext context, String type) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChooseTypePage(type: type)),
    ).then((selectedType) {
      if (type == 'chooseDonationType') {
        setState(() {
          donationType = selectedType;
        });
      } else if (type == 'chooseFoodType') {
        setState(() {
          foodType = selectedType;
        });
      }
    });
  }
}

class ChooseTypePage extends StatelessWidget {
  final String type;

  const ChooseTypePage({Key? key, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: type == 'chooseDonationType'
            ? const Text('Escolha o tipo de doação')
            : const Text('Selecione o tipo de alimento'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.pop(context, 'Paypal');
            },
            child: Image.asset('assets/option1.png'),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context, 'Cartao de Credito');
            },
            child: Image.asset('assets/option2.png'),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context, 'Cartao de Debito');
            },
            child: Image.asset('assets/option3.png'),
          ),
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
