import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_flutter/screens/settings/presentation/widgets/sleep_data_input.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SleepMonitoringPage extends StatefulWidget {
  @override
  _SleepMonitoringPageState createState() => _SleepMonitoringPageState();
}

class _SleepMonitoringPageState extends State<SleepMonitoringPage> {
  int selectedSegment = 0;
  final DateFormat dateFormat = DateFormat('MMM dd, yyyy');
  DateTime selectedDate = DateTime.now();
  List<SleepRecord> records = [];
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  late String uid;

  @override
  void initState() {
    super.initState();
    uid = auth.currentUser!.uid;
    fetchData();
  }

  void fetchData() async {
    QuerySnapshot snapshot = await firestore.collection('users').doc(uid).collection('sleepData').get();
    List<QueryDocumentSnapshot> documents = snapshot.docs;
    List<SleepRecord> tempRecords = [];

    for (var doc in documents) {
      var data = doc.data() as Map<String, dynamic>;
      DateTime dateTime = (data['dateTime'] as Timestamp).toDate();
      double duration = data['duration'];
      tempRecords.add(SleepRecord(dateTime: dateTime, duration: duration));
    }

    setState(() {
      records = tempRecords;
    });
  }

  List<FlSpot> getSpots() {
    return records.map((record) => FlSpot(record.dateTime.millisecondsSinceEpoch.toDouble(), record.duration)).toList();
  }

  String getBottomTitle(double value) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
    return dateFormat.format(date);
  }

  void _navigateToInputPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SleepDataInputPage()),
    );

    if (result != null) {
      final newRecord = SleepRecord(
        dateTime: DateTime.now(),
        duration: _calculateDuration(result['начало'], result['конец']),
      );
      await firestore.collection('users').doc(uid).collection('sleepData').add({
        'dateTime': newRecord.dateTime,
        'duration': newRecord.duration,
      });
      setState(() {
        records.add(newRecord);
      });
    }
  }

  double _calculateDuration(String start, String end) {
    final startTime = DateFormat('HH:mm').parse(start);
    final endTime = DateFormat('HH:mm').parse(end);
    final duration = endTime.difference(startTime).inHours.toDouble();
    return duration < 0 ? 24 + duration : duration; // Handle overnight sleep
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Мониторинг сна'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ToggleButtons(
              isSelected: [selectedSegment == 0, selectedSegment == 1, selectedSegment == 2],
              onPressed: (int index) {
                setState(() {
                  selectedSegment = index;
                });
              },
              children: [
                Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('День')),
                Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('Неделя')),
                Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('Месяц')),
              ],
            ),
            SizedBox(height: 16),
            Text(
              dateFormat.format(selectedDate),
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Expanded(
              child: LineChart(
                LineChartData(
                  minX: records.isNotEmpty ? records.last.dateTime.millisecondsSinceEpoch.toDouble() : 0,
                  maxX: records.isNotEmpty ? records.first.dateTime.millisecondsSinceEpoch.toDouble() : 1,
                  minY: 0,
                  maxY: 24, // Sleep duration is measured in hours, max 24
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            space: 8.0,
                            child: Text(getBottomTitle(value), style: TextStyle(color: Colors.black, fontSize: 10)),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            space: 8.0,
                            child: Text('${value.toInt()}h', style: TextStyle(color: Colors.black, fontSize: 10)),
                          );
                        },
                      ),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: getSpots(),
                      isCurved: true,
                      barWidth: 4,
                      color: Colors.purple,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _navigateToInputPage();
              },
              child: Text('Добавить запись'),
            ),
            SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildNoteSection('1.Рекомендации по сну', _buildSleepGuidelinesInfo()),
                    _buildNoteSection('2.Важность сна', _buildSleepImportanceInfo()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteSection(String title, Widget content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ExpansionTile(
        title: Text(title),
        children: [content],
      ),
    );
  }

  Widget _buildSleepGuidelinesInfo() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        'По данным Национального фонда сна, рекомендуемая продолжительность сна для взрослых составляет 7-9 часов в сутки.'
        'Детям и подросткам нужно больше спать, чтобы поддерживать свой рост и развитие.'
      ),
    );
  }

  Widget _buildSleepImportanceInfo() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        'Полноценный сон имеет решающее значение для общего состояния здоровья и хорошего самочувствия. Он помогает улучшить память, настроение и когнитивные функции.'
        'Плохой сон может привести к различным проблемам со здоровьем, включая ожирение, болезни сердца и депрессию.',
      ),
    );
  }
}

class SleepRecord {
  final DateTime dateTime;
  final double duration;

  SleepRecord({required this.dateTime, required this.duration});
}