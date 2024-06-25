import 'package:fitness_flutter/core/const/color_constants.dart';
import 'package:flutter/material.dart';

class FitnessAppBar {
  FitnessAppBar._();

  static PreferredSizeWidget? withTitle(
      {required BuildContext context, required String title}) {
    return AppBar(
      centerTitle: false,
      titleSpacing: 0,
      title: Text(
        title,
        style: TextStyle(color: Colors.black, fontSize: 18),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new,
          color: ColorConstants.primaryColor,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }
}
