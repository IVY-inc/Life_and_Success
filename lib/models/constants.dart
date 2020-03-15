import 'package:flutter/foundation.dart';

//if authenticated user has no profile Image...
//stub Image is used
const kProfileImage =
    'https://www.pngitem.com/pimgs/m/506-5067022_sweet-shap-profile-placeholder-hd-png-download.png';

//Gender class
enum Gender { Male, Female }

///For
///*****Planner Screen*****..
/// Mapping each number to days of the week
///
Map<int, String> week = {
  7: 'Sunday',
  1: 'Monday',
  2: 'Tuesday',
  3: 'Wednesday',
  4: 'Thurday',
  5: 'Friday',
  6: 'Saturday',
};

///For
///****GoalPlannerScreen****
/// and Planner itself.. Model of a [GoalItem]
///
class GoalItem {
  DateTime date;
  String title;
  String id;
  String description;
  bool done;
  GoalItem(
      {@required this.date,
      @required this.title,
      @required this.id,
      @required this.done,
      this.description});
}

enum GoalType { Short, Long }
