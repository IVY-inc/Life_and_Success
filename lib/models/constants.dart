import 'package:flutter/material.dart';

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
  int hoursCount;
  bool done;
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

//Colors I used for LongGoals UI design
List<MaterialColor> colors = [
  Colors.red,
  Colors.blue,
  Colors.green,
  Colors.purple,
  Colors.yellow,
  Colors.orange,
  Colors.cyan
];

class SubMusicSection {
  final String musicSubTitle;
  final int musicCount;
  final String thumbnailUrl;
  final String id;
  const SubMusicSection(
      {this.musicSubTitle, this.musicCount, this.id, this.thumbnailUrl});
  String get title {
    return musicSubTitle;
  }

  String get subtitle {
    return '$musicCount audios';
  }
}

class MainMusicSection {
  final String sectionTitle;
  final List<SubMusicSection> children;
  MainMusicSection(this.sectionTitle, this.children);
}

//stub data for books
//TODO: use providers later to provide books
final books = List.generate(15, (_) => 'Lorem ipsum');
