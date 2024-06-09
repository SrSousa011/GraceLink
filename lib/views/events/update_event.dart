import 'package:churchapp/views/events/events.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UpdateEventForm extends StatefulWidget {
  final Event event;

  const UpdateEventForm({super.key, required this.event});

  @override
  State<StatefulWidget> createState() => _UpdateEventFormState();
}

class _UpdateEventFormState extends State<UpdateEventForm> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.event.title);
    _descriptionController =
        TextEditingController(text: widget.event.description);
    _locationController = TextEditingController(text: widget.event.location);
    _selectedDate = widget.event.date;
    _selectedTime = widget.event.time;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
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

  Future<void> _updateEvent(BuildContext context) async {
    if (_titleController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _selectedDate != null &&
        _selectedTime != null) {
      final updatedEvent = Event(
        id: widget.event.id,
        title: _titleController.text,
        description: _descriptionController.text,
        date: _selectedDate!,
        time: _selectedTime!,
        location: _locationController.text,
      );
      try {
        await updateEvent(updatedEvent, widget.event.id);
        Navigator.pop(context, true); // Return true to indicate success
      } catch (e) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Erro ao atualizar evento'),
              content:
                  const Text('Ocorreu um erro ao tentar atualizar o evento.'),
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
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Erro ao atualizar evento'),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Atualizar Evento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitleEvent(),
            const SizedBox(height: 20.0),
            _buildDescriptionEvent(),
            const SizedBox(height: 20.0),
            _buildSlectDate(),
            const SizedBox(height: 20.0),
            _builSelecTime(),
            const SizedBox(height: 20.0),
            _builSelecLocation(),
            const SizedBox(height: 20.0),
            _buildUpdateButton(),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleEvent() {
    return TextField(
      controller: _titleController,
      decoration: const InputDecoration(
        labelText: 'Título do Evento',
        icon: Icon(Icons.title),
      ),
    );
  }

  Widget _buildDescriptionEvent() {
    return TextField(
      controller: _descriptionController,
      decoration: const InputDecoration(
        labelText: 'Descrição do Evento',
        icon: Icon(Icons.description),
      ),
    );
  }

  Widget _buildSlectDate() {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: () => _selectDate(context),
        ),
        if (_selectedDate != null)
          Text(
            DateFormat('dd/MM/yyyy').format(_selectedDate!),
            style: const TextStyle(fontSize: 18.0),
          ),
      ],
    );
  }

  Widget _builSelecTime() {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.access_time),
          onPressed: () => _selectTime(context),
        ),
        if (_selectedTime != null)
          Text(
            _selectedTime!.format(context),
            style: const TextStyle(fontSize: 18.0),
          ),
      ],
    );
  }

  Widget _builSelecLocation() {
    return TextField(
      controller: _locationController,
      decoration: const InputDecoration(
        labelText: 'Localização',
        icon: Icon(Icons.location_on),
      ),
    );
  }

  Widget _buildUpdateButton() {
    return ElevatedButton(
      onPressed: () => _updateEvent(context),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF5AAFf9),
      ),
      child: const Text('Atualizar'),
    );
  }
}
