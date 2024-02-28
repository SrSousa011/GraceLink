import 'package:churchapp/views/nav_bar.dart';
import 'package:flutter/material.dart';

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
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextField(
            controller: donationController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'Digite o valor da sua doação',
            ),
          ),
          // Paymment Dropdown
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
                    'Cartão de crédito',
                    'cartão de débito'
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
          const SizedBox(height: 20.0),
          const SizedBox(height: 50.0),
          const Text(
            'Doar como:',
            style: TextStyle(
              fontSize: 24.0, // Ajuste o tamanho do texto conforme desejado
              fontWeight:
                  FontWeight.bold, // Ajuste o estilo do texto conforme desejado
              color: Color.fromARGB(255, 153, 153,
                  153), // Ajuste a cor do texto conforme desejado
            ),
          ),
          const SizedBox(height: 20.0),
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
          const SizedBox(height: 50.0),
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
      drawer: const NavBar(),
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
