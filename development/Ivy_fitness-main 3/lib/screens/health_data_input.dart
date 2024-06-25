import 'package:fitness_flutter/screens/workouts/page/workouts_page.dart';
import 'package:flutter/material.dart';

class HealthDataInputPage extends StatelessWidget {
  const HealthDataInputPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController ageController = TextEditingController();
    TextEditingController weightController = TextEditingController();
    TextEditingController heightController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Input Health Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: ageController,
              decoration: InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: weightController,
              decoration: InputDecoration(labelText: 'Weight (kg)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: heightController,
              decoration: InputDecoration(labelText: 'Height (cm)'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Save the health data to your database
                // ...

                // Navigate to the workouts page
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => WorkoutsPage(),
                  ),
                );
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
