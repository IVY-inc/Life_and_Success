import 'package:flutter/material.dart';

class SleepDataInputPage extends StatefulWidget {
  @override
  _SleepDataInputPageState createState() => _SleepDataInputPageState();
}

class _SleepDataInputPageState extends State<SleepDataInputPage> {
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ввод данных о режиме сна'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _startController,
              decoration: InputDecoration(labelText: 'Время начала (HH:mm)'),
              keyboardType: TextInputType.datetime,
            ),
            TextField(
              controller: _endController,
              decoration: InputDecoration(labelText: 'Время окончания (HH:mm)'),
              keyboardType: TextInputType.datetime,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                String startTime = _startController.text;
                String endTime = _endController.text;
                // Handle input validation and data processing here

                Navigator.pop(context, {'начало': startTime, 'конец': endTime});
              },
              child: Text('отправьте '),
            ),
          ],
        ),
      ),
    );
  }
}
