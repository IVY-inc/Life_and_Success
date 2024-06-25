import 'package:flutter/material.dart';

extension AppSpacer on num {
  Widget get verticalGap => SizedBox(
        height: toDouble(),
      );

  Widget get horizontalGap => SizedBox(
        width: toDouble(),
      );
}
