// ignore_for_file: unused_element

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class WeightPage extends StatefulWidget {
  const WeightPage();

  @override
  State<WeightPage> createState() => _WeightPageState();
}

class _WeightPageState extends State<WeightPage> {
  String selectedView = 'День';
  double weight = 80.2; // Example weight
  double initialWeight = 80.0; // Example initial weight
  double targetWeight = 81.4; // Example target weight
  List<FlSpot> weightData = [
    FlSpot(1, 80.0),
    FlSpot(2, 80.1),
    FlSpot(3, 80.2),
    FlSpot(4, 80.3),
    FlSpot(5, 80.4),
    // Add more data points for example purposes
  ];

  void _changeView(String view) {
    setState(() {
      selectedView = view;
    });
  }

  void _addRecord(double newWeight) {
    setState(() {
      weightData.add(FlSpot(weightData.length + 1.0, newWeight));
      weight = newWeight;
    });
  }

  void _updateGoal(double newInitialWeight, double newTargetWeight) {
    setState(() {
      initialWeight = newInitialWeight;
      targetWeight = newTargetWeight;
    });
  }

  Widget _buildView() {
    switch (selectedView) {
      case 'День':
        return DayView(
            weight: weight,
            initialWeight: initialWeight,
            targetWeight: targetWeight);
      case 'Неделя':
        return WeekView(weightData: weightData);
      case 'Месяц':
        return MonthView(weightData: weightData);
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.9),
      appBar: AppBar(
        title: Text('Управление весом'),
      ),
      body: Column(
        children: [
          ToggleButtons(
            isSelected: [
              selectedView == 'День',
              selectedView == 'Неделя',
              selectedView == 'Месяц',
            ],
            onPressed: (int index) {
              _changeView(['День', 'Неделя', 'Месяц'][index]);
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
            child: _buildView(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newWeight = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddRecordPage()),
          );
          if (newWeight != null) {
            _addRecord(newWeight);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class DayView extends StatelessWidget {
  final double weight;
  final double initialWeight;
  final double targetWeight;

  const DayView({
    required this.weight,
    required this.initialWeight,
    required this.targetWeight,
  });

  get result => null;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('BMI 27.8 Overweight', style: TextStyle(fontSize: 16)),
          ),
        ),
        Text('$weight kg',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
        Text('Initial weight: $initialWeight kg'),
        Text('Total gained: ${weight - initialWeight} kg'),
        Text('Target weight: $targetWeight kg'),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ManageGoalPage(
                      initialWeight: initialWeight,
                      targetWeight: targetWeight)),
            );
          },
          child: Text('Управление целью'),
        ),
        ElevatedButton(
          onPressed: () async {
            final newWeight = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddRecordPage()),
            );
            if (newWeight != null) {
              // Update the weight record
              final newInitialWeight = result['initialWeight'];
              final newTargetWeight = result['targetWeight'];
              _updateGoal(newInitialWeight, newTargetWeight);
            }
          },
          child: Text('Добавить запись'),
        ),
        ElevatedButton(
          onPressed: () {
            // Implement the functionality for measure
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MeasurePage()),
            );
          },
          child: Text('Измерьте'),
        ),
      ],
    );
  }
}

void _updateGoal(double newInitialWeight, double newTargetWeight) {}

class WeekView extends StatelessWidget {
  final List<FlSpot> weightData;

  const WeekView({required this.weightData});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Средний вес: 80,1 кг',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
        SizedBox(
          height: 300,
          child: LineChart(
            LineChartData(
              minX: 1,
              maxX: 7,
              minY: 0,
              maxY: 200,
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 50,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        'Day ${value.toInt()}',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      );
                    },
                  ),
                ),
              ),
              gridData: FlGridData(
                show: true,
                horizontalInterval: 50,
                drawVerticalLine: true,
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(color: Colors.black, width: 1),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: weightData.where((spot) => spot.x <= 7).toList(),
                  isCurved: true,
                  color: Colors.blue,
                  barWidth: 2,
                  belowBarData: BarAreaData(
                      show: true, color: Colors.blue.withOpacity(0.3)),
                ),
              ],
            ),
          ),
        ),
        Text('Еженедельные записи веса'),
      ],
    );
  }
}

class MonthView extends StatelessWidget {
  final List<FlSpot> weightData;

  const MonthView({required this.weightData});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Средний вес: 80,1 кг',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
        SizedBox(
          height: 300,
          child: LineChart(
            LineChartData(
              minX: 1,
              maxX: 30,
              minY: 0,
              maxY: 200,
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 50,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 5,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      );
                    },
                  ),
                ),
              ),
              gridData: FlGridData(
                show: true,
                horizontalInterval: 50,
                drawVerticalLine: true,
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(color: Colors.black, width: 1),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: weightData,
                  isCurved: true,
                  color: Colors.blue,
                  barWidth: 2,
                  belowBarData: BarAreaData(
                      show: true, color: Colors.blue.withOpacity(0.3)),
                ),
              ],
            ),
          ),
        ),
        Text('Ежемесячные записи о весе'),
      ],
    );
  }
}

class AddRecordPage extends StatefulWidget {
  @override
  _AddRecordPageState createState() => _AddRecordPageState();
}

class _AddRecordPageState extends State<AddRecordPage> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Добавить запись о весе'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _weightController,
                decoration: InputDecoration(labelText: 'Вес(кг)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите свой вес';
                  }
                  final weight = double.tryParse(value);
                  if (weight == null) {
                    return 'Пожалуйста,введите действительное значение';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newWeight = double.parse(_weightController.text);
                    Navigator.pop(context, newWeight);
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

class MeasurePage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Измерьте'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _weightController,
                decoration: InputDecoration(labelText: 'Вес(кг)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите свой вес';
                  }
                  final weight = double.tryParse(value);
                  if (weight == null) {
                    return 'Пожалуйста,введите действительное значение';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newWeight = double.parse(_weightController.text);
                    Navigator.pop(context, newWeight);
                  }
                },
                child: Text('Сохранение результатов измерений'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ManageGoalPage extends StatefulWidget {
  final double initialWeight;
  final double targetWeight;

  const ManageGoalPage({
    required this.initialWeight,
    required this.targetWeight,
  });

  @override
  _ManageGoalPageState createState() => _ManageGoalPageState();
}

class _ManageGoalPageState extends State<ManageGoalPage> {
  final _formKey = GlobalKey<FormState>();
  final _initialWeightController = TextEditingController();
  final _targetWeightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initialWeightController.text = widget.initialWeight.toString();
    _targetWeightController.text = widget.targetWeight.toString();
  }

  @override
  void dispose() {
    _initialWeightController.dispose();
    _targetWeightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Управление целью'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _initialWeightController,
                decoration: InputDecoration(labelText: 'Начальный вес (кг)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите свой начальный вес';
                  }
                  final weight = double.tryParse(value);
                  if (weight == null) {
                    return 'Пожалуйста, введите действительное значение';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _targetWeightController,
                decoration: InputDecoration(labelText: 'Целевой вес (кг)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите ваш целевой вес';
                  }
                  final weight = double.tryParse(value);
                  if (weight == null) {
                    return 'Пожалуйста, введите действительное значение';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final initialWeight =
                        double.parse(_initialWeightController.text);
                    final targetWeight =
                        double.parse(_targetWeightController.text);
                    Navigator.pop(context, {
                      'initialWeight': initialWeight,
                      'targetWeight': targetWeight
                    });
                  }
                },
                child: Text('Сохранить цель'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
