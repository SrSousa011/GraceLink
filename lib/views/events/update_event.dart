import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:churchapp/views/events/event_service.dart';

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

        if (!context.mounted) return;
        Navigator.pop(context, true);
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
        backgroundColor: Colors.grey[800], // Updated color
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitleField(),
            const SizedBox(height: 20.0),
            _buildDescriptionField(),
            const SizedBox(height: 20.0),
            _buildDateField(),
            const SizedBox(height: 20.0),
            _buildTimeField(),
            const SizedBox(height: 20.0),
            _buildLocationField(),
            const SizedBox(height: 20.0),
            _buildUpdateButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleField() {
    return TextField(
      controller: _titleController,
      decoration: InputDecoration(
        labelText: 'Título do Evento',
        prefixIcon: Icon(Icons.title, color: Colors.grey[700]), // Updated color
      ),
    );
  }

  Widget _buildDescriptionField() {
    return TextField(
      controller: _descriptionController,
      decoration: InputDecoration(
        labelText: 'Descrição do Evento',
        prefixIcon:
            Icon(Icons.description, color: Colors.grey[700]), // Updated color
      ),
    );
  }

  Widget _buildDateField() {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: AbsorbPointer(
        child: TextFormField(
          controller: TextEditingController(
            text: _selectedDate != null
                ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
                : '',
          ),
          decoration: InputDecoration(
            labelText: 'Data do Evento',
            prefixIcon: Icon(Icons.calendar_today,
                color: Colors.grey[700]), // Updated color
          ),
        ),
      ),
    );
  }

  Widget _buildTimeField() {
    return GestureDetector(
      onTap: () => _selectTime(context),
      child: AbsorbPointer(
        child: TextFormField(
          controller: TextEditingController(
            text: _selectedTime != null ? _selectedTime!.format(context) : '',
          ),
          decoration: InputDecoration(
            labelText: 'Hora do Evento',
            prefixIcon: Icon(Icons.access_time,
                color: Colors.grey[700]), // Updated color
          ),
        ),
      ),
    );
  }

  Widget _buildLocationField() {
    return TextField(
      controller: _locationController,
      decoration: InputDecoration(
        labelText: 'Localização',
        prefixIcon:
            Icon(Icons.location_on, color: Colors.grey[700]), // Updated color
      ),
    );
  }

  Widget _buildUpdateButton() {
    return ElevatedButton(
      onPressed: () => _updateEvent(context),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.grey[800], // Updated color
      ),
      child: const Text('Atualizar'),
    );
  }
}
