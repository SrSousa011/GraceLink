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
  const DonationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donations'),
      ),
      body: const DonationWidget(),
    );
  }
}

class DonationWidget extends StatefulWidget {
  const DonationWidget({Key? key}) : super(key: key);

  @override
  DonationWidgetState createState() => DonationWidgetState();
}

class DonationWidgetState extends State<DonationWidget> {
  double donationAmount = 0.0;
  String? donationType;
  String? foodType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Valor da Doação: € $donationAmount',
            style: const TextStyle(fontSize: 20.0),
          ),
          const SizedBox(height: 20.0),
          TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'Digite o valor da sua doação',
            ),
            onChanged: (value) {
              setState(() {
                donationAmount = double.tryParse(value) ?? 0.0;
              });
            },
          ),
          const SizedBox(height: 20.0),
          const Text('Doar como:'),
          ElevatedButton.icon(
            onPressed: () {
              _navigateToChooseTypePage(context, 'chooseDonationType');
            },
            icon: const Icon(Icons.payment),
            label: const Text('Escolha o tipo de doação'),
          ),
          const SizedBox(height: 10.0),
          ElevatedButton.icon(
            onPressed: () {
              _navigateToChooseTypePage(context, 'chooseFoodType');
            },
            icon: const Icon(Icons.food_bank),
            label: const Text('Selecione o tipo de alimento'),
          ),
          const SizedBox(height: 20.0),
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

  const ChooseTypePage({super.key, required this.type});

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
