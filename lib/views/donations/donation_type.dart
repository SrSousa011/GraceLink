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
  late String selectedDonationType = '';
  late String selectedFoodType = '';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(left: 25.0),
            child: Text(
              'Tipo de Doação:',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 153, 153, 153),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 150,
                height: 150,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DonationOptionsScreen(
                          onTypeSelected: (type) {
                            setState(() {
                              selectedDonationType = type;
                            });
                            widget.onTypeSelected(type);
                          },
                        ),
                      ),
                    );
                    if (result != null) {
                      setState(() {
                        selectedDonationType = result;
                      });
                    }
                  },
                  icon: const Icon(Icons.attach_money),
                  label: Text(selectedDonationType.isEmpty
                      ? "Escolha o tipo de doaçzão"
                      : selectedDonationType),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(22.0), // Borda quadrada
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              SizedBox(
                width: 150,
                height: 150,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FoodOptionsScreen(
                          onTypeSelected: (type) {
                            setState(() {
                              selectedFoodType = type;
                            });
                            widget.onTypeSelected(type);
                          },
                        ),
                      ),
                    );
                    if (result != null) {
                      setState(() {
                        selectedFoodType = result;
                      });
                    }
                  },
                  icon: const Icon(Icons.food_bank),
                  label: Text(selectedFoodType.isEmpty
                      ? "Selecione o tipo de alimento"
                      : selectedFoodType),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(22.0), // Borda quadrada
                    ),
                  ),
                ),
              ),
            ],
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
              Navigator.pop(context, "Dízimo");
            },
            child: const ListTile(
              title: Text("Dízimo"),
            ),
          ),
          InkWell(
            onTap: () {
              onTypeSelected("Oferta");
              Navigator.pop(context, "Oferta");
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
              Navigator.pop(context, "Projeto doar e amar");
            },
            child: const ListTile(
              title: Text("Projeto doar e amar"),
            ),
          ),
          InkWell(
            onTap: () {
              onTypeSelected("Missão África");
              Navigator.pop(context, "Missão África");
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
