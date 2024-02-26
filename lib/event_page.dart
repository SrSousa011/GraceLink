import 'package:churchapp/MenuDrawer.dart';
import 'package:flutter/material.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  List<Event> events = [
    Event(
      name: 'Evento 1',
      type: 'Tipo 1',
      date: '10/03/2024 14:00',
      location: 'Local 1',
    ),
    Event(
      name: 'Evento 2',
      type: 'Tipo 2',
      date: '15/03/2024 16:00',
      location: 'Local 2',
    ),
    Event(
      name: 'Evento 3',
      type: 'Tipo 3',
      date: '20/03/2024 10:00',
      location: 'Local 3',
    ),
  ];

  String _selectedEventType =
      ''; // Variável para armazenar o tipo de evento selecionado
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _eventDateController = TextEditingController();
  final TextEditingController _eventEndDateController = TextEditingController();
  final TextEditingController _eventLocationController =
      TextEditingController();

  DateTime? _selectedDate; // Variável para armazenar a data selecionada
  DateTime?
      _selectedEndDate; // Variável para armazenar a data de término selecionada

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eventos'),
      ),
      drawer: const MenuDrawer(),
      body: SafeArea(
        child: ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(events[index].name),
              subtitle: Text(events[index].type),
              onTap: () {
                // Implemente o que acontece quando um evento é selecionado
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addEvent,
        tooltip: 'Adicionar Evento',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addEvent() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Novo Evento'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _eventNameController,
                  decoration:
                      const InputDecoration(labelText: 'Nome do Evento'),
                ),
                DropdownButtonFormField<String>(
                  value: _selectedEventType,
                  hint: const Text('Escolha o Tipo do Evento'),
                  onChanged: (String? value) {
                    setState(() {
                      _selectedEventType = value!;
                    });
                  },
                  items: <String>['Tipo 1', 'Tipo 2', 'Tipo 3']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                TextFormField(
                  controller: _eventDateController,
                  decoration: const InputDecoration(
                      labelText: 'Data do Evento (dd/mm/aaaa hh:mm)'),
                  onTap: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (selectedDate != null) {
                      setState(() {
                        _selectedDate = selectedDate;
                        _eventDateController.text = selectedDate.toString();
                      });
                    }
                  },
                ),
                if (_selectedDate != null)
                  TextFormField(
                    controller: _eventEndDateController,
                    decoration: const InputDecoration(
                        labelText:
                            'Data de Término do Evento (dd/mm/aaaa hh:mm)'),
                    onTap: () async {
                      final selectedEndDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (selectedEndDate != null) {
                        setState(() {
                          _selectedEndDate = selectedEndDate;
                          _eventEndDateController.text =
                              selectedEndDate.toString();
                        });
                      }
                    },
                  ),
                TextField(
                  controller: _eventLocationController,
                  decoration:
                      const InputDecoration(labelText: 'Local do Evento'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('Salvar'),
              onPressed: () {
                // Verifica se todos os campos estão preenchidos
                if (_eventNameController.text.isNotEmpty &&
                    _selectedEventType.isNotEmpty &&
                    _eventDateController.text.isNotEmpty &&
                    _eventLocationController.text.isNotEmpty) {
                  // Criar o objeto Event com as informações coletadas
                  Event newEvent = Event(
                    name: _eventNameController.text,
                    type: _selectedEventType,
                    date: _eventDateController.text,
                    endDate: _eventEndDateController.text.isNotEmpty
                        ? _eventEndDateController.text
                        : null,
                    location: _eventLocationController.text,
                  );

                  // Adicionar o novo evento à lista de eventos
                  setState(() {
                    events.add(newEvent);
                  });

                  // Fechar o diálogo
                  Navigator.pop(context);
                } else {
                  // Exibe um snackbar se algum campo estiver vazio
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Por favor, preencha todos os campos.')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}

class Event {
  final String name;
  final String type;
  final String date;
  final String? endDate; // Pode ser nulo se não houver data de término
  final String location;

  Event({
    required this.name,
    required this.type,
    required this.date,
    this.endDate,
    required this.location,
  });
}

void main() {
  runApp(const MaterialApp(
    home: EventPage(),
  ));
}
