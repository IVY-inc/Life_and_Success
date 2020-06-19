import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/goal.dart';
import '../../models/constants.dart';

int i = 0; //Used for colors

class EachGoal extends StatefulWidget {
  final GoalItem goalItem;
  final Function editDeleteCancel;
  final GoalType type;
  EachGoal(this.goalItem, this.editDeleteCancel, this.type);
  @override
  _EachGoalState createState() => _EachGoalState();
}

class _EachGoalState extends State<EachGoal> {
  DateTime last;
  DateTime today;
  bool val;

  @override
  void initState() {
    try {
      last = widget.goalItem.checkList.last;
    } catch (e) {
      last = DateTime.now().subtract(Duration(days: 1));
    }
    print(last);
    today = DateTime.now();
    val = last.month == today.month && last.day == today.day;
    super.initState();
  }

  MaterialColor _randomColor() {
    i++;
    return colors[(i - 1) % 7];
  }

  String nextCheckPt() {
    String result = "";
    for (int i = 0; i < widget.goalItem.checkpoints.length; i++) {
      if (!widget.goalItem.checkpoints[i].done) {
        result = widget.goalItem.checkpoints[i].checkpointDescription;
        break;
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    String result;
    if(widget.type==GoalType.Long)
      result = nextCheckPt();
    var width =
        MediaQuery.of(context).size.width - 26; //borderRadius and margin
    var goalProvider = Provider.of<Goal>(context);
    markGoalAsRead(bool b) {
      if (val) {
        Scaffold.of(context).removeCurrentSnackBar();
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('Goal has been marked as done for the day!'),
        ));
        return;
      }
      if (widget.goalItem.startDate.isAfter(DateTime.now())) {
        Scaffold.of(context).removeCurrentSnackBar();
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(
              'Goal startDate is ${DateFormat('EEE d/M').format(widget.goalItem.startDate)}. Hold goal down to EDIT'),
        ));
        return;
      }
      val = true;
      widget.type == GoalType.Long
          ? goalProvider.markLongGoalAsRead(widget.goalItem)
          : goalProvider.markShortGoalAsRead(widget.goalItem);
      setState(() {});
    }

    return Stack(alignment: Alignment.center, children: [
      GestureDetector(
        onLongPress: () => widget.editDeleteCancel(context, widget.goalItem),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 6),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 7,
                offset: Offset(0, 3),
              )
            ],
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: CheckboxListTile(
              value: val,
              onChanged: markGoalAsRead,
              title: Text(
                widget.goalItem.title,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration:
                        val ? TextDecoration.lineThrough : TextDecoration.none),
              ),
              subtitle: Text(widget.type == GoalType.Short
                  ? 'Last Checked: ${val ? 'Today' : DateFormat('EEE d/M/y').format(last)}'
                  : 'Next checkpt: $result'),
              checkColor: Colors.white,
              activeColor: Colors.greenAccent),
        ),
      ),
      if (widget.type == GoalType.Long)
        Positioned(
            bottom: 0,
            child: Container(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                child: Row(
                    children: widget.goalItem.checkpoints
                        .map((check) => Container(
                              width: width / widget.goalItem.checkpoints.length,
                              height: 5,
                              color: check.done ? _randomColor() : Colors.grey,
                            ))
                        .toList())))
    ]);
  }
}
