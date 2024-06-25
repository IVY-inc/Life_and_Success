import 'package:fitness_flutter/core/extensions/spacer_extension.dart';
import 'package:flutter/material.dart';

class AppDivider extends StatelessWidget {
  const AppDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 35.0, right: 10.0),
      child: Column(
        children: [
          10.verticalGap,
          Divider(color: Colors.grey.withOpacity(0.4)),
          10.verticalGap,
        ],
      ),
    );
  }
}
