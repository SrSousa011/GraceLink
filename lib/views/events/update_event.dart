import 'package:flutter/material.dart';
import 'package:churchapp/views/events/event_service.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:churchapp/theme/theme_provider.dart';

class UpdateEventForm extends StatefulWidget {
  final Event event;

  const UpdateEventForm({super.key, required this.event});

  @override
  State<UpdateEventForm> createState() => _UpdateEventFormState();
}

class _UpdateEventFormState extends State<UpdateEventForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late DateTime _date;
  late TimeOfDay _time;
  late TextEditingController _locationController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.event.title);
    _descriptionController =
        TextEditingController(text: widget.event.description);
    _date = widget.event.date;
    _time = widget.event.time;
    _locationController = TextEditingController(text: widget.event.location);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Event'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField('Title', _titleController, Icons.title,
                isDarkMode: isDarkMode),
            const SizedBox(height: 20.0),
            _buildTextField(
                'Description', _descriptionController, Icons.description,
                isDarkMode: isDarkMode),
            const SizedBox(height: 20.0),
            _buildDateField(isDarkMode: isDarkMode),
            const SizedBox(height: 20.0),
            _buildTimeField(isDarkMode: isDarkMode),
            const SizedBox(height: 20.0),
            _buildLocationField(isDarkMode: isDarkMode),
            const SizedBox(height: 20.0),
            _buildSaveButton(isDarkMode: isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      String labelText, TextEditingController controller, IconData icon,
      {required bool isDarkMode}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        icon: Icon(icon, color: isDarkMode ? Colors.white : Colors.blue),
        labelStyle: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
      ),
      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a $labelText';
        }
        return null;
      },
    );
  }

  Widget _buildDateField({required bool isDarkMode}) {
    return TextFormField(
      onTap: () => _selectDate(context),
      readOnly: true,
      decoration: InputDecoration(
        labelText: _date != null
            ? DateFormat('dd/MM/yyyy').format(_date)
            : 'Select Date',
        icon: Icon(Icons.calendar_today,
            color: isDarkMode ? Colors.white : Colors.blue),
        labelStyle: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
      ),
      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
    );
  }

  Widget _buildTimeField({required bool isDarkMode}) {
    return TextFormField(
      onTap: () => _selectTime(context),
      readOnly: true,
      decoration: InputDecoration(
        // ignore: unnecessary_null_comparison
        labelText: _time != null ? _time.format(context) : 'Select Time',
        icon: Icon(Icons.access_time,
            color: isDarkMode ? Colors.white : Colors.blue),
        labelStyle: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
      ),
      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
    );
  }

  Widget _buildLocationField({required bool isDarkMode}) {
    return TextFormField(
      controller: _locationController,
      decoration: InputDecoration(
        labelText: 'Location',
        icon: Icon(Icons.location_on,
            color: isDarkMode ? Colors.white : Colors.blue),
        labelStyle: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
      ),
      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
    );
  }

  Widget _buildSaveButton({required bool isDarkMode}) {
    return ElevatedButton(
      onPressed: _saveEvent,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: isDarkMode ? Colors.grey[800] : Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      child: const Text('Save Event'),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _date) {
      setState(() {
        _date = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (picked != null && picked != _time) {
      setState(() {
        _time = picked;
      });
    }
  }

  void _saveEvent() {
    if (_formKey.currentState?.validate() ?? false) {
      final updatedEvent = Event(
        id: widget.event.id,
        title: _titleController.text,
        description: _descriptionController.text,
        date: _date,
        time: _time,
        location: _locationController.text,
      );

      Navigator.pop(context, updatedEvent);
    }
  }
}
