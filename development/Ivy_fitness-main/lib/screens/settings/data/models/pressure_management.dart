import 'package:flutter/material.dart';

class PressureManagement {
  final String title;
  final String description;
  final IconData icon;

  PressureManagement(
      {required this.title, required this.description, required this.icon});
}

final pressureManagement = [
  PressureManagement(
      title: 'цели здравоохранения',
      description: 'Здоровье артериального давления',
      icon: Icons.monitor_heart_outlined),
  PressureManagement(
      title: 'Измерение \nплан',
      description: 'Запланированные напоминания',
      icon: Icons.schedule)
];
