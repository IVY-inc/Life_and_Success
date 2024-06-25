import 'package:fitness_flutter/core/extensions/spacer_extension.dart';
import 'package:fitness_flutter/core/extensions/string_extension.dart';
import 'package:fitness_flutter/screens/settings/data/models/measurement.dart';
import 'package:flutter/material.dart';

class MeasurementsTile extends StatelessWidget {
  final Measurement measurement;
  const MeasurementsTile({required this.measurement});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => measurement.page)),
      child: Row(
        children: [
          Icon(
            measurement.icon,
            size: 25,
          ),
          10.horizontalGap,
          Text(
            measurement.measurementTitle.orEmpty,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          Spacer(),
          Text(
            measurement.measurementValue.orEmpty,
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.grey,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }
}
