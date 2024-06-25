import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Assuming you're using fl_chart for charting
import 'package:intl/intl.dart';

class Spo2MeasurementScreen extends StatefulWidget {
  @override
  _Spo2MeasurementScreenState createState() => _Spo2MeasurementScreenState();
}

class _Spo2MeasurementScreenState extends State<Spo2MeasurementScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<FlSpot> spo2Spots = [];
  double averageSpo2 = 0;
  String lastTime = '--';
  String lowestHighest = '--';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<String?> getCurrentUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      return null;
    }
  }

  void fetchData() async {
    try {
      String? uid = await getCurrentUserId();
      QuerySnapshot snapshot = await firestore
          .collection('users')
          .doc(uid)
          .collection('spo2Data')
          .orderBy('dateTime', descending: true)
          .get();
      List<QueryDocumentSnapshot> documents = snapshot.docs;
      List<FlSpot> tempSpots = [];
      double totalSpo2 = 0;
      double minSpo2 = double.infinity;
      double maxSpo2 = double.negativeInfinity;

      for (int i = 0; i < documents.length; i++) {
        var data = documents[i].data() as Map<String, dynamic>;
        DateTime dateTime = (data['dateTime'] as Timestamp).toDate();
        double spo2 = data['value'];
        tempSpots.add(FlSpot(dateTime.millisecondsSinceEpoch.toDouble(), spo2));
        totalSpo2 += spo2;
        if (spo2 < minSpo2) minSpo2 = spo2;
        if (spo2 > maxSpo2) maxSpo2 = spo2;
      }

      setState(() {
        spo2Spots = tempSpots;
        averageSpo2 = documents.isNotEmpty ? totalSpo2 / documents.length : 0;
        lastTime = documents.isNotEmpty ? DateFormat('MMM dd, yyyy HH:mm').format((documents.first['dateTime'] as Timestamp).toDate()) : '--';
        lowestHighest = documents.isNotEmpty ? '$minSpo2 - $maxSpo2' : '--';
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  void _addRecord(Spo2Record newRecord) async {
    String? uid = await getCurrentUserId();
    if (uid == null) return;

    await firestore
        .collection('users')
        .doc(uid)
        .collection('spo2Data')
        .add({
      'dateTime': newRecord.dateTime,
      'value': newRecord.value,
    });

    fetchData(); // Refresh the data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SpO₂'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'notes') {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => NotesScreen()),
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'notes',
                child: Text('Notes'),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SpO₂ Уровни',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Средний SpO₂: ${averageSpo2.toStringAsFixed(1)}%',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Container(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spo2Spots,
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 4,
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildInfoCard('Последний раз', lastTime),
                _buildInfoCard('Самый низкий-Самый высокий', lowestHighest),
              ],
            ),
            SizedBox(height: 20),
            Text(
              '<70%',
              style: TextStyle(color: Colors.red),
            ),
            Text(
              '70 - 89%',
              style: TextStyle(color: Colors.orange),
            ),
            Text(
              '90 - 100%',
              style: TextStyle(color: Colors.green),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final newRecord = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddSpo2RecordPage()),
                );
                if (newRecord != null) {
                  _addRecord(newRecord);
                }
              },
              child: Text('Добавить запись'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(value, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

class Spo2Record {
  final DateTime dateTime;
  final double value;

  Spo2Record({required this.dateTime, required this.value});
}

class AddSpo2RecordPage extends StatefulWidget {
  @override
  _AddSpo2RecordPageState createState() => _AddSpo2RecordPageState();
}

class _AddSpo2RecordPageState extends State<AddSpo2RecordPage> {
  final TextEditingController spo2Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('бавить запись Spo2'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: spo2Controller,
              decoration: InputDecoration(labelText: 'SpO₂ Уровни(0-100)'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                double? spo2 = double.tryParse(spo2Controller.text);

                if (spo2 != null) {
                  final newRecord = Spo2Record(
                    dateTime: DateTime.now(),
                    value: spo2,
                  );
                  Navigator.pop(context, newRecord);
                }
              },
              child: Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}

class NotesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Заметки'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '1.Что такое насыщение крови кислородом (SpO₂)?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Насыщение крови кислородом (spo₂) – это процентное содержание гемоглобина в крови, содержащего кислород, другими словами, количество кислорода в крови',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '2.На что следует обратить внимание при измерении Spo2',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              '1. Для получения данных включите функцию Spot на носимом устройстве. Следуйте инструкциям на экране, чтобы завершить измерения...',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}