import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StressLevelPage extends StatefulWidget {
  @override
  _StressLevelPageState createState() => _StressLevelPageState();
}

class _StressLevelPageState extends State<StressLevelPage> {
  int selectedSegment = 0;
  final DateFormat dateFormat = DateFormat('MMM dd, yyyy');
  DateTime selectedDate = DateTime.now();
  List<StressLevelRecord> records = [];
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  late String uid;

  @override
  void initState() {
    super.initState();
    uid = auth.currentUser!.uid;
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      QuerySnapshot snapshot = await firestore
          .collection('users')
          .doc(uid)
          .collection('stress')
          .orderBy('dateTime', descending: true)
          .get();

      List<QueryDocumentSnapshot> documents = snapshot.docs;
      List<StressLevelRecord> tempRecords = [];

      for (var doc in documents) {
        var data = doc.data() as Map<String, dynamic>;
        DateTime dateTime = (data['dateTime'] as Timestamp).toDate();
        int stressLevel = data['level'];
        tempRecords.add(StressLevelRecord(dateTime: dateTime, stressLevel: stressLevel));
      }

      setState(() {
        records = tempRecords;
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  Future<String?> getCurrentUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      return null;
    }
  }

  void _addRecord(StressLevelRecord newRecord) async {
    String? uid = await getCurrentUserId();
    if (uid == null) return;

    await firestore
        .collection('users')
        .doc(uid)
        .collection('stress')
        .add({
      'dateTime': newRecord.dateTime,
      'level': newRecord.stressLevel,
    });

    fetchData(); // Refresh the data
  }

  List<FlSpot> getSpots() {
    List<FlSpot> spots;
    switch (selectedSegment) {
      case 0:
        spots = records
            .where((record) => record.dateTime.isAfter(selectedDate.subtract(Duration(days: 1))) && record.dateTime.isBefore(selectedDate.add(Duration(days: 1))))
            .map((record) => FlSpot(record.dateTime.millisecondsSinceEpoch.toDouble(), record.stressLevel.toDouble()))
            .toList();
        break;
      case 1:
        DateTime startOfWeek = selectedDate.subtract(Duration(days: selectedDate.weekday - 1));
        spots = records
            .where((record) => record.dateTime.isAfter(startOfWeek.subtract(Duration(days: 1))) && record.dateTime.isBefore(startOfWeek.add(Duration(days: 7))))
            .map((record) => FlSpot(record.dateTime.millisecondsSinceEpoch.toDouble(), record.stressLevel.toDouble()))
            .toList();
        break;
      case 2:
        DateTime startOfMonth = DateTime(selectedDate.year, selectedDate.month, 1);
        DateTime endOfMonth = DateTime(selectedDate.year, selectedDate.month + 1, 0);
        spots = records
            .where((record) => record.dateTime.isAfter(startOfMonth.subtract(Duration(days: 1))) && record.dateTime.isBefore(endOfMonth.add(Duration(days: 1))))
            .map((record) => FlSpot(record.dateTime.millisecondsSinceEpoch.toDouble(), record.stressLevel.toDouble()))
            .toList();
        break;
      default:
        spots = [];
    }
    return spots;
  }

  String getBottomTitle(double value) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
    switch (selectedSegment) {
      case 0:
        return DateFormat('HH:mm').format(date);
      case 1:
        return DateFormat('EEE').format(date);
      case 2:
        return DateFormat('MMM dd').format(date);
      default:
        return dateFormat.format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Уровни стресса'),
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
                Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('Week')),
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
              child: records.isEmpty
                  ? Center(child: Text('Данные об уровне стресса отсутствуют.'))
                  : LineChart(
                      LineChartData(
                        minX: records.isNotEmpty ? records.last.dateTime.millisecondsSinceEpoch.toDouble() : 0,
                        maxX: records.isNotEmpty ? records.first.dateTime.millisecondsSinceEpoch.toDouble() : 1,
                        minY: 0,
                        maxY: 10,
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
                                  child: Text('${value.toInt()}', style: TextStyle(color: Colors.black, fontSize: 10)),
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
                            color: Colors.blue,
                          ),
                        ],
                      ),
                    ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final newRecord = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddStressLevelRecordPage()),
                );
                if (newRecord != null) {
                  _addRecord(newRecord);
                }
              },
              child: Text('Add Record'),
            ),
            SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildNoteSection('1. Stress levels', _buildStressLevelsInfo()),
                    _buildNoteSection('2. Managing stress', _buildStressManagementInfo()),
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

  Widget _buildStressLevelsInfo() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        'Уровень стресса можно измерить по шкале от 0 до 10, где 0 означает отсутствие стресса, а 10 - сильный стресс. '
        'Регулярный мониторинг может помочь выявить закономерности и триггеры стресса.',
      ),
    );
  }

  Widget _buildStressManagementInfo() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        'Борьба со стрессом включает в себя различные методы, такие как регулярные физические упражнения, полноценный сон, здоровое питание, '
        'практикуйте осознанность и при необходимости обращайтесь за профессиональной помощью.',
      ),
    );
  }
}

class StressLevelRecord {
  final DateTime dateTime;
  final int stressLevel;

  StressLevelRecord({required this.dateTime, required this.stressLevel});
}

class AddStressLevelRecordPage extends StatefulWidget {
  @override
  _AddStressLevelRecordPageState createState() => _AddStressLevelRecordPageState();
}

class _AddStressLevelRecordPageState extends State<AddStressLevelRecordPage> {
  final TextEditingController stressLevelController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Добавить запись об уровне стресса'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: stressLevelController,
              decoration: InputDecoration(labelText: 'Уровень стресса (0-10)'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                int? stressLevel = int.tryParse(stressLevelController.text);

                if (stressLevel != null) {
                  final newRecord = StressLevelRecord(
                    dateTime: DateTime.now(),
                    stressLevel: stressLevel,
                  );
                  Navigator.pop(context, newRecord);
                }
              },
              child: Text('Добавь'),
            ),
          ],
        ),
      ),
    );
  }
}