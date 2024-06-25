import 'package:fitness_flutter/core/const/text_constants.dart';
import 'package:fitness_flutter/screens/settings/presentation/pages/blood_pressure_page.dart';
import 'package:fitness_flutter/screens/settings/presentation/pages/sleep_monitoring_page.dart';
import 'package:fitness_flutter/screens/settings/presentation/pages/weight_page.dart';
import 'package:fitness_flutter/screens/settings/presentation/pages/spo_page.dart';
import 'package:fitness_flutter/screens/settings/presentation/pages/heart_page.dart';
import 'package:fitness_flutter/screens/settings/presentation/pages/stress_page.dart';
import 'package:flutter/material.dart';

class Measurement {
  final String? measurementTitle;
  final IconData? icon;
  final String? measurementValue;
  final Widget page;

  Measurement(
      {this.measurementTitle,
      required this.page,
      this.icon,
      this.measurementValue});
}

final measurementList = [
  Measurement(
      page: HeartPage  (),
      measurementTitle: TextConstants.heart,
      icon: Icons.monitor_heart_outlined,
      measurementValue: '46 bpm'),
  Measurement(
      page: WeightPage(),
      measurementTitle: TextConstants.weight,
      icon: Icons.monitor_weight_outlined,
      measurementValue: '60.0 kg'),
  Measurement(
    page: StressLevelPage (),
      measurementTitle: TextConstants.stress,
      icon: Icons.speed_outlined,
      measurementValue: '--'),
  Measurement(
      page: Spo2MeasurementScreen (),
      measurementTitle: TextConstants.chemical,
      icon: Icons.science_outlined,
      measurementValue: '--'),
  Measurement(
      page: SleepMonitoringPage (),
      measurementTitle: TextConstants.sleep,
      icon: Icons.bedtime_outlined,
      measurementValue: '--'),
  Measurement(
      page: BloodPressurePage(),
      measurementTitle: TextConstants.bloodPressure,
      icon: Icons.bloodtype_outlined,
      measurementValue: '--'),
];
