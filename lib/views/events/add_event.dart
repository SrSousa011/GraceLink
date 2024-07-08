import 'package:churchapp/provider/user_provider.dart';
import 'package:churchapp/views/events/event_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddEventForm extends StatefulWidget {
  const AddEventForm({super.key});

  @override
  State<AddEventForm> createState() => _AddEventFormState();
}

class _AddEventFormState extends State<AddEventForm> {
  late TextEditingController _idController;
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String _location = '';

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _selectedDate = DateTime.now();
    _selectedTime = TimeOfDay.now();
  }

  @override
  void dispose() {
    _idController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _saveEvent(BuildContext context) async {
    // Verificar se todos os campos estão preenchidos
    if (_titleController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _selectedDate != null &&
        _selectedTime != null) {
      // Criar um novo evento
      final newEvent = Event(
        id: _idController.text,
        title: _titleController.text,
        description: _descriptionController.text,
        date: _selectedDate!,
        time: _selectedTime!,
        location: _location,
      );

      try {
        await addEvent(newEvent);

        if (!context.mounted) return;
        Navigator.pop(context, true);
      } catch (e) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Erro ao salvar evento'),
              content: Text(
                  'Ocorreu um erro ao tentar salvar o evento: ${e.toString()}'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } else {
      // Mostrar um diálogo de erro se algum campo estiver vazio
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Erro ao salvar evento'),
            content: const Text('Por favor, preencha todos os campos.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Novo Evento'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Título do Evento',
                icon: Icon(Icons.title),
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Descrição do Evento',
                icon: Icon(Icons.description),
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              onTap: () => _selectDate(context),
              readOnly: true,
              decoration: InputDecoration(
                labelText: _selectedDate != null
                    ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
                    : 'Selecionar Data',
                icon: const Icon(Icons.calendar_today),
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              onTap: () => _selectTime(context),
              readOnly: true,
              decoration: InputDecoration(
                labelText: _selectedTime != null
                    ? _selectedTime!.format(context)
                    : 'Selecionar Hora',
                icon: const Icon(Icons.access_time),
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Localização do Evento',
                icon: Icon(Icons.location_on),
              ),
              onChanged: (value) {
                setState(() {
                  _location = value;
                });
              },
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () => _saveEvent(context),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: const Text('Salvar Evento'),
            ),
          ]),
        ),
      ),
    );
  }
}
