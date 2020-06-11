import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/goal.dart';
import '../../models/constants.dart';

class EachGoal extends StatefulWidget {
  final GoalItem goalItem;
  final Function editDeleteCancel;
  EachGoal(this.goalItem, this.editDeleteCancel);
  @override
  _EachGoalState createState() => _EachGoalState();
}

class _EachGoalState extends State<EachGoal> {
  DateTime last;
  DateTime today;
  bool val;

  @override
  void initState() {
    try{
    last = widget.goalItem.checkList.last;
    }catch(e){
      last = DateTime.now().subtract(Duration(days:1));
    }
    print(last);
    today = DateTime.now();
    val = last.month == today.month && last.day == today.day;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
      goalProvider.markGoalAsRead(
          widget.goalItem.id, widget.goalItem.checkCount,widget.goalItem.checkList);
      setState(() {});
    }

    return GestureDetector(
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
            subtitle: Text(
                'Last Checked: ${val ? 'Today' : DateFormat('EEE d/M/y').format(last)}'),
            checkColor: Colors.white,
            activeColor: Colors.greenAccent),
      ),
    );
  }
}
