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
          ElevatedButton.icon(
            onPressed: () {
              _showDonationDialog();
            },
            icon: const Icon(Icons.attach_money),
            label: const Text("Escolha o tipo de doação"),
          ),
          const SizedBox(height: 20), // Espaçamento entre os botões
          ElevatedButton.icon(
            onPressed: () {
              _showFoodDialog();
            },
            icon: const Icon(Icons.food_bank),
            label: const Text("Selecione o tipo de alimento"),
          ),
        ],
      ),
    );
  }

  void _showDonationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Escolha o tipo de doação"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                  widget.onTypeSelected("Dizimo");
                },
                child: const ListTile(
                  title: Text("Dízimo"),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                  widget.onTypeSelected("Oferta");
                },
                child: const ListTile(
                  title: Text("Oferta"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showFoodDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Selecione o tipo de alimento"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                  widget.onTypeSelected("Projeto doar e amar");
                },
                child: const ListTile(
                  title: Text("Projeto doar e amar"),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                  widget.onTypeSelected("Missao Africa");
                },
                child: const ListTile(
                  title: Text("Missão África"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
