import 'package:flutter/material.dart';

class DonationType extends StatefulWidget {
  final void Function(String) onTypeSelected;

  const DonationType({
    Key? key,
    required this.onTypeSelected,
    required String donationType,
  }) : super(key: key);

  @override
  State<DonationType> createState() => _DonationTypeState();
}

class _DonationTypeState extends State<DonationType> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Tipo de Doação:', // Adicionando rótulo
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 153, 153, 153),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DonationOptionsScreen(
                    onTypeSelected: widget.onTypeSelected,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.attach_money),
            label: const Text("Escolha o tipo de doação"),
          ),
          const SizedBox(height: 20), // Espaçamento entre os botões
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FoodOptionsScreen(
                    onTypeSelected: widget.onTypeSelected,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.food_bank),
            label: const Text("Selecione o tipo de alimento"),
          ),
        ],
      ),
    );
  }
}

class DonationOptionsScreen extends StatelessWidget {
  final void Function(String) onTypeSelected;

  const DonationOptionsScreen({Key? key, required this.onTypeSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Escolha o tipo de doação"),
      ),
      body: Column(
        children: <Widget>[
          InkWell(
            onTap: () {
              onTypeSelected("Dízimo");
              Navigator.pop(context); // Close the current screen
            },
            child: const ListTile(
              title: Text("Dízimo"),
            ),
          ),
          InkWell(
            onTap: () {
              onTypeSelected("Oferta");
              Navigator.pop(context); // Close the current screen
            },
            child: const ListTile(
              title: Text("Oferta"),
            ),
          ),
        ],
      ),
    );
  }
}

class FoodOptionsScreen extends StatelessWidget {
  final void Function(String) onTypeSelected;

  const FoodOptionsScreen({Key? key, required this.onTypeSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Selecione o tipo de alimento"),
      ),
      body: Column(
        children: <Widget>[
          InkWell(
            onTap: () {
              onTypeSelected("Projeto doar e amar");
              Navigator.pop(context); // Close the current screen
            },
            child: const ListTile(
              title: Text("Projeto doar e amar"),
            ),
          ),
          InkWell(
            onTap: () {
              onTypeSelected("Missão África");
              Navigator.pop(context); // Close the current screen
            },
            child: const ListTile(
              title: Text("Missão África"),
            ),
          ),
        ],
      ),
    );
  }
}
