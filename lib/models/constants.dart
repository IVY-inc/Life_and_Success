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

class LongGoalData {
  final int order;
  final String checkpointDescription;
  final int hoursCount;
  final bool done;
  LongGoalData(
    this.order,
    this.checkpointDescription,
    this.hoursCount,
    this.done,
  );
}

class GoalItem {
  DateTime startDate;
  DateTime endDate;
  List<DateTime> checkList;
  String title;
  List<LongGoalData> checkpoints;
  int checkCount;
  String id;
  String description;
  GoalItem(
      {@required this.startDate,
      this.endDate, //needed for the short goals to calculate
      this.checkCount, //shortGoal specific
      this.checkpoints, //for the long goals exclusively
      this.checkList, //List of DateTimes where clicks were made
      @required this.title,
      @required this.id,
      this.description});
}

enum GoalType { Short, Long }
