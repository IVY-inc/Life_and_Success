import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BloodPressurePage extends StatefulWidget {
  @override
  _BloodPressurePageState createState() => _BloodPressurePageState();
}

class _BloodPressurePageState extends State<BloodPressurePage> {
  int selectedSegment = 0;
  final DateFormat dateFormat = DateFormat('MMM dd, yyyy');
  DateTime selectedDate = DateTime.now();
  List<BloodPressureRecord> records = [];
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
          .collection('bloodPressureData')
          .orderBy('dateTime', descending: true)
          .get();
      
      List<QueryDocumentSnapshot> documents = snapshot.docs;
      List<BloodPressureRecord> tempRecords = [];

      for (var doc in documents) {
        var data = doc.data() as Map<String, dynamic>;
        DateTime dateTime = (data['dateTime'] as Timestamp).toDate();
        int systolic = data['systolic'];
        int diastolic = data['diastolic'];
        tempRecords.add(BloodPressureRecord(
            dateTime: dateTime, systolic: systolic, diastolic: diastolic));
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

  void _addRecord(BloodPressureRecord newRecord) async {
    String? uid = await getCurrentUserId();
    if (uid == null) return;

    await firestore
        .collection('users')
        .doc(uid)
        .collection('bloodPressureData')
        .add({
      'dateTime': newRecord.dateTime,
      'systolic': newRecord.systolic,
      'diastolic': newRecord.diastolic,
    });

    fetchData(); // Refresh the data
  }

  List<FlSpot> getSystolicSpots() {
    return records
        .map((record) => FlSpot(
            record.dateTime.millisecondsSinceEpoch.toDouble(),
            record.systolic.toDouble()))
        .toList();
  }

  List<FlSpot> getDiastolicSpots() {
    return records
        .map((record) => FlSpot(
            record.dateTime.millisecondsSinceEpoch.toDouble(),
            record.diastolic.toDouble()))
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
        title: Text('кровяное давление'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ToggleButtons(
              isSelected: [
                selectedSegment == 0,
                selectedSegment == 1,
                selectedSegment == 2
              ],
              onPressed: (int index) {
                setState(() {
                  selectedSegment = index;
                });
              },
              children: [
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('День')),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Неделя')),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Месяц')),
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
                  ? Center(child: Text('Данные о кровяном давлении отсутствуют.'))
                  : LineChart(
                      LineChartData(
                        minX: records.isNotEmpty
                            ? records.last.dateTime.millisecondsSinceEpoch.toDouble()
                            : 0,
                        maxX: records.isNotEmpty
                            ? records.first.dateTime.millisecondsSinceEpoch.toDouble()
                            : 1,
                        minY: 60,
                        maxY: 160,
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                return SideTitleWidget(
                                  axisSide: meta.axisSide,
                                  space: 8.0,
                                  child: Text(getBottomTitle(value),
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 10)),
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
                                  child: Text('${value.toInt()}',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 10)),
                                );
                              },
                            ),
                          ),
                        ),
                        gridData: FlGridData(show: true),
                        borderData: FlBorderData(show: true),
                        lineBarsData: [
                          LineChartBarData(
                            spots: getSystolicSpots(),
                            isCurved: true,
                            barWidth: 4,
                            color: Colors.red,
                          ),
                          LineChartBarData(
                            spots: getDiastolicSpots(),
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
                  MaterialPageRoute(builder: (context) => AddBloodPressureRecordPage()),
                );
                if (newRecord != null) {
                  _addRecord(newRecord);
                }
              },
              child: Text('Добавить запись'),
            ),
            SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildNoteSection('1.Уровень кровяного давления (mmHg)',
                        _buildBloodPressureLevelsTable()),
                    _buildNoteSection(
                        '2. Низкое кровяное давление', _buildLowBloodPressureInfo()),
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

  Widget _buildBloodPressureLevelsTable() {
    return Table(
      border: TableBorder.all(color: Colors.grey),
      children: [
        TableRow(children: [
          TableCell(
              child: Padding(
                  padding: const EdgeInsets.all(8.0), child: Text('Категория'))),
          TableCell(
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Систолическое (верхнее)'))),
          TableCell(
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Диастолическое (нижнее)'))),
        ]),
        TableRow(children: [
          TableCell(
              child: Padding(
                  padding: const EdgeInsets.all(8.0), child: Text('Суровый'))),
          TableCell(
              child: Padding(
                  padding: const EdgeInsets.all(8.0), child: Text('≥ 180'))),
          TableCell(
              child: Padding(
                  padding: const EdgeInsets.all(8.0), child: Text('≥ 110'))),
        ]),
        // Add more rows as needed
      ],
    );
  }

  Widget _buildLowBloodPressureInfo() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
          'Артериальная гипотензия не имеет четкого определения, но обычно рассматривается как следующее: систолическое давление ≤90 мм рт.ст., диастолическое давление ≤ 60 мм рт.ст., систолическое давление < 140 мм рт.ст. Приведенные выше данные носят исключительно справочный характер и не должны использоваться для медицинской диагностики или лечения.'),
    );
  }
}

class BloodPressureRecord {
  final DateTime dateTime;
  final int systolic;
  final int diastolic;

  BloodPressureRecord(
      {required this.dateTime,
      required this.systolic,
      required this.diastolic});
}

class AddBloodPressureRecordPage extends StatefulWidget {
  @override
  _AddBloodPressureRecordPageState createState() => _AddBloodPressureRecordPageState();
}

class _AddBloodPressureRecordPageState extends State<AddBloodPressureRecordPage> {
  final TextEditingController systolicController = TextEditingController();
  final TextEditingController diastolicController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Добавить запись артериального давления'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: systolicController,
              decoration: InputDecoration(labelText: 'Систолическое давление'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: diastolicController,
              decoration: InputDecoration(labelText: 'Диастолическое давление'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                int? systolic = int.tryParse(systolicController.text);
                int? diastolic = int.tryParse(diastolicController.text);

                if (systolic != null && diastolic != null) {
                  final newRecord = BloodPressureRecord(
                    dateTime: DateTime.now(),
                    systolic: systolic,
                    diastolic: diastolic,
                  );
                  Navigator.pop(context, newRecord);
                }
              },
              child: Text('Добавить'),
            ),
          ],
        ),
      ),
    );
  }
}