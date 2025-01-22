// File: lib/screens/edit_countdown_screen.dart
import 'package:flutter/material.dart';
import '../models/countdown_event.dart';

class EditCountdownScreen extends StatefulWidget {
  final CountdownEvent countdown;

  const EditCountdownScreen({
    Key? key,
    required this.countdown,
  }) : super(key: key);

  @override
  _EditCountdownScreenState createState() => _EditCountdownScreenState();
}

class _EditCountdownScreenState extends State<EditCountdownScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.countdown.title);
    _descriptionController = TextEditingController(text: widget.countdown.description);
    _selectedDate = widget.countdown.targetDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Countdown'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveChanges,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                title: Text(
                  'Target Date: ${_selectedDate.toString().split(' ')[0]}',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 3650)),
                  );
                  if (picked != null) {
                    final TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(_selectedDate),
                    );
                    if (pickedTime != null) {
                      setState(() {
                        _selectedDate = DateTime(
                          picked.year,
                          picked.month,
                          picked.day,
                          pickedTime.hour,
                          pickedTime.minute,
                        );
                      });
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveChanges() {
    widget.countdown.title = _titleController.text;
    widget.countdown.description = _descriptionController.text;
    widget.countdown.targetDate = _selectedDate;
    widget.countdown.save(); // Now this will work since CountdownEvent extends HiveObject
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Changes saved successfully'),
        duration: Duration(seconds: 2),
      ),
    );
    
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}