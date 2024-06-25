import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HeartPage extends StatefulWidget {
  @override
  _HeartPageState createState() => _HeartPageState();
}

class _HeartPageState extends State<HeartPage> {
  String selectedView = 'День';
  List<HeartRateRecord> records = [];
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final DateFormat dateFormat = DateFormat('MMM dd, yyyy');
  final DateFormat timeFormat = DateFormat('hh:mm a');

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
      if (uid == null) return;

      QuerySnapshot snapshot = await firestore
          .collection('users')
          .doc(uid)
          .collection('heartRateData')
          .orderBy('dateTime', descending: true)
          .get();

      List<QueryDocumentSnapshot> documents = snapshot.docs;
      List<HeartRateRecord> tempRecords = [];

      for (var doc in documents) {
        var data = doc.data() as Map<String, dynamic>;
        DateTime dateTime = (data['dateTime'] as Timestamp).toDate();
        int heartRate = data['heartRate'];
        tempRecords.add(HeartRateRecord(dateTime: dateTime, heartRate: heartRate));
      }

      setState(() {
        records = tempRecords;
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  void _addRecord(HeartRateRecord newRecord) async {
    String? uid = await getCurrentUserId();
    if (uid == null) return;

    await firestore
        .collection('users')
        .doc(uid)
        .collection('heartRateData')
        .add({
      'dateTime': newRecord.dateTime,
      'heartRate': newRecord.heartRate,
    });

    fetchData(); // Refresh the data
  }

  List<FlSpot> getHeartRateData() {
    return records
        .map((record) => FlSpot(
            record.dateTime.millisecondsSinceEpoch.toDouble(),
            record.heartRate.toDouble()))
        .toList();
  }

  String getBottomTitle(double value) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
    return dateFormat.format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Частота сердцебиения'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ToggleButtons(
              isSelected: [
                selectedView == 'День',
                selectedView == 'Неделя',
                selectedView == 'Месяц',
              ],
              onPressed: (int index) {
                setState(() {
                  selectedView = ['День', 'Неделя', 'Месяц'][index];
                });
              },
              children: const <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('День'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('Неделя'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('Месяц'),
                ),
              ],
            ),
            Expanded(
              child: records.isEmpty
                  ? Center(child: Text('Данные о частоте сердечных сокращений отсутствуют.'))
                  : LineChart(
                      LineChartData(
                        minX: records.isNotEmpty
                            ? records.last.dateTime.millisecondsSinceEpoch.toDouble()
                            : 0,
                        maxX: records.isNotEmpty
                            ? records.first.dateTime.millisecondsSinceEpoch.toDouble()
                            : 1,
                        minY: 40,
                        maxY: 200,
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                return SideTitleWidget(
                                  axisSide: meta.axisSide,
                                  space: 8.0,
                                  child: Text(
                                    getBottomTitle(value),
                                    style: TextStyle(color: Colors.black, fontSize: 10),
                                  ),
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
                                  child: Text(
                                    '${value.toInt()}',
                                    style: TextStyle(color: Colors.black, fontSize: 10),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        gridData: FlGridData(show: true),
                        borderData: FlBorderData(show: true),
                        lineBarsData: [
                          LineChartBarData(
                            spots: getHeartRateData(),
                            isCurved: true,
                            barWidth: 4,
                            color: Colors.red,
                          ),
                        ],
                      ),
                    ),
            ),
            ElevatedButton(
              onPressed: () async {
                final newRecord = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddHeartRecordPage()),
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
}

class HeartRateRecord {
  final DateTime dateTime;
  final int heartRate;

  HeartRateRecord({required this.dateTime, required this.heartRate});
}

class AddHeartRecordPage extends StatefulWidget {
  @override
  _AddHeartRecordPageState createState() => _AddHeartRecordPageState();
}

class _AddHeartRecordPageState extends State<AddHeartRecordPage> {
  final _formKey = GlobalKey<FormState>();
  final _heartRateController = TextEditingController();

  @override
  void dispose() {
    _heartRateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Добавить запись частоты сердечных сокращений'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _heartRateController,
                decoration: InputDecoration(labelText: 'частота сердцебиения(bpm)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите свой пульс';
                  }
                  final heartRate = int.tryParse(value);
                  if (heartRate == null) {
                    return 'Пожалуйста,введите действительный номер';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newHeartRate = int.parse(_heartRateController.text);
                    final newRecord = HeartRateRecord(
                      dateTime: DateTime.now(),
                      heartRate: newHeartRate,
                    );
                    Navigator.pop(context, newRecord);
                  }
                },
                child: Text('Добавить запись'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}