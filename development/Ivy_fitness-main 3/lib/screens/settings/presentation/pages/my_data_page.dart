import 'package:fitness_flutter/core/const/text_constants.dart';
import 'package:fitness_flutter/core/extensions/spacer_extension.dart';
import 'package:fitness_flutter/screens/common_widgets/fitness_app_bar.dart';
import 'package:fitness_flutter/screens/settings/data/models/measurement.dart';
import 'package:fitness_flutter/screens/settings/presentation/widgets/app_divider.dart';
import 'package:fitness_flutter/screens/settings/presentation/widgets/measurements_tile.dart';
import 'package:flutter/material.dart';

class MyDataPage extends StatelessWidget {
  const MyDataPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FitnessAppBar.withTitle(context: context, title: 'Мои данные'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            10.verticalGap,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                TextConstants.healthMeasurements,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            30.verticalGap,
            ListView.separated(
                shrinkWrap: true,
                itemCount: measurementList.length,
                separatorBuilder: (context, index) => AppDivider(),
                itemBuilder: (context, index) =>
                    MeasurementsTile(measurement: measurementList[index])),
          ],
        ),
      ),
    );
  }
}
