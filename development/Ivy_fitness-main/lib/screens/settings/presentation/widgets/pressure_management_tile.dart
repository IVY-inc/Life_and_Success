import 'package:fitness_flutter/core/const/color_constants.dart';
import 'package:fitness_flutter/core/extensions/spacer_extension.dart';
import 'package:fitness_flutter/screens/settings/data/models/pressure_management.dart';
import 'package:flutter/material.dart';

class PressureManagementTile extends StatelessWidget {
  final PressureManagement pressureManagement;
  const PressureManagementTile({required this.pressureManagement});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ColorConstants.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pressureManagement.title,
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
                6.verticalGap,
                Text(pressureManagement.description),
              ],
            ),
            Column(
              children: [
                Icon(
                  pressureManagement.icon,
                  color: ColorConstants.pink,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
