import 'package:flutter/material.dart';

class event_page extends StatefulWidget {
  @override
  _event_pageState createState() => _event_pageState();
}

class _event_pageState extends State<event_page> {
  List<String> events = [
    'Evento 1',
    'Evento 2',
    'Evento 3',
  ];

  String newEvent = ''; // Variável para armazenar o novo evento

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eventos'),
      ),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(events[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addEvent();
        },
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
          content: TextField(
            autofocus: true,
            onChanged: (value) {
              newEvent = value; // Atualiza o valor do novo evento
            },
            onSubmitted: (value) {
              setState(() {
                events.add(newEvent); // Adiciona o novo evento à lista
              });
              Navigator.pop(context); // Fecha o diálogo
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.pop(context); // Fecha o diálogo
              },
            ),
            TextButton(
              child: const Text('Salvar'),
              onPressed: () {
                setState(() {
                  events.add(newEvent); // Adiciona o novo evento à lista
                });
                Navigator.pop(context); // Fecha o diálogo
              },
            ),
          ],
        );
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: event_page(),
  ));
}
