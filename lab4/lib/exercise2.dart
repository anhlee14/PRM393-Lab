import 'package:flutter/material.dart';

class Exercise2Screen extends StatefulWidget {
  const Exercise2Screen({super.key});

  @override
  State<Exercise2Screen> createState() => _Exercise2ScreenState();
}

class _Exercise2ScreenState extends State<Exercise2Screen> {
  double _rating = 50;
  bool _isActive = false;
  String _selectedGenre = 'None';
  DateTime? _selectedDate;

  void _openDatePicker() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 2 – Input Contr...'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Rating (Slider)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Slider(
              value: _rating,
              min: 0,
              max: 100,
              onChanged: (val) {
                setState(() {
                  _rating = val;
                });
              },
            ),
            Text('Current value: ${_rating.toInt()}'),
            const SizedBox(height: 20),

            const Text(
              'Active (Switch)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Is movie active?'),
              value: _isActive,
              onChanged: (val) {
                setState(() {
                  _isActive = val;
                });
              },
            ),
            const SizedBox(height: 20),

            const Text(
              'Genre (RadioListTile)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            RadioListTile<String>(
              title: const Text('Action'),
              value: 'Action',
              groupValue: _selectedGenre,
              onChanged: (val) {
                setState(() {
                  _selectedGenre = val!;
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('Comedy'),
              value: 'Comedy',
              groupValue: _selectedGenre,
              onChanged: (val) {
                setState(() {
                  _selectedGenre = val!;
                });
              },
            ),
            Text('Selected genre: $_selectedGenre'),
            if (_selectedDate != null)
              Text('Selected date: ${_selectedDate!.toLocal()}'.split(' ')[0]),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: _openDatePicker,
                child: const Text('Open Date Picker'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}