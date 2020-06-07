import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import './each_goal.dart';
import '../../models/constants.dart';
import '../../providers/goal.dart';

class GoalListDialog extends StatefulWidget {
  final GoalType type;
  GoalListDialog({@required this.type});

  @override
  _GoalListDialogState createState() => _GoalListDialogState();
}

class _GoalListDialogState extends State<GoalListDialog> {
  addNewGoal(
      {@required BuildContext context,
      bool editMode = false,
      GoalItem g}) async {
    assert(editMode ^ (g == null));
    //XORing the conditions to make sure one of 'em is true while the other false

    bool hasError = false, taskdone = false;
    final provider = Provider.of<Goal>(context, listen: false);
    if (await showCupertinoDialog<bool>(
            context: context,
            builder: (ctx) => CupertinoAlertDialog(
                  actions: <Widget>[
                    CupertinoDialogAction(
                        child: Text(editMode ? 'Edit Goal' : 'Add Goal'),
                        onPressed: () {
                          if (!NewGoalInputDialogState.formKey.currentState
                              .validate()) {
                            return;
                          }
                          if (NewGoalInputDialogState.startDate == null ||
                              NewGoalInputDialogState.endDate == null) {
                            setState(() {
                              NewGoalInputDialogState.dateError = true;
                            });
                            return;
                          }
                          NewGoalInputDialogState.dateError = false;
                          try {
                            widget.type == GoalType.Long
                                ? provider.addLongGoal(
                                    id: g?.id,
                                    //time: NewGoalInputDialogState.goalTime,
                                    title: NewGoalInputDialogState
                                        .titleController.text,
                                    description: NewGoalInputDialogState
                                        .descriptionController.text)
                                : provider.addShortGoal(
                                    id: g?.id,
                                    startDate:
                                        NewGoalInputDialogState.startDate,
                                    endDate: NewGoalInputDialogState.endDate,
                                    title: NewGoalInputDialogState
                                        .titleController.text,
                                    description: NewGoalInputDialogState
                                        .descriptionController.text);
                            taskdone = true;
                          } catch (e) {
                            print(e);
                            taskdone = true;
                            hasError = true;
                          }
                          Navigator.of(ctx).pop(taskdone);
                        }),
                    CupertinoDialogAction(
                      child: Text('Cancel'),
                      isDestructiveAction: true,
                      onPressed: () => Navigator.of(ctx).pop(),
                    )
                  ],
                  title: Text(
                      'Set ${widget.type == GoalType.Long ? 'a Lifetime' : 'an Instant'} goal'),
                  content: NewGoalInputDialog(widget.type, g),
                )) ??
        false) {
      showCupertinoDialog(
          context: context,
          builder: (ctx) => CupertinoAlertDialog(
                title: Text(hasError ? 'Error!' : 'Success!'),
                content: hasError
                    ? Icon(
                        CupertinoIcons.clear_circled_solid,
                        color: Colors.red,
                      )
                    : Icon(
                        CupertinoIcons.check_mark_circled_solid,
                        color: Colors.green,
                      ),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text('Ok'),
                    isDefaultAction: true,
                    onPressed: () => Navigator.of(ctx).pop(),
                  )
                ],
              ));
    }
    setState(() {});
  }

  editDeleteCancel(BuildContext context, GoalItem g) {
    final provider = Provider.of<Goal>(context, listen: false);
    showCupertinoDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
              title: Text('Perform an Action'),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text('Edit'),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    addNewGoal(context: context, editMode: true, g: g);
                  },
                ),
                CupertinoDialogAction(
                  child: Text('Delete'),
                  isDestructiveAction: true,
                  onPressed: () {
                    widget.type == GoalType.Short
                        ? provider.deleteShortGoal(g.id)
                        : provider.deleteLongGoal(g.id);
                    Navigator.of(ctx).pop();
                    setState(() {});
                  },
                ),
                CupertinoDialogAction(
                    child: Text('Cancel'),
                    isDefaultAction: true,
                    onPressed: () => Navigator.of(ctx).pop()),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Goal>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
            '${widget.type == GoalType.Long ? 'LIFETIME GOALS' : 'INSTANT GOALS'}'),
        actions: <Widget>[
          FlatButton(
            padding: EdgeInsets.all(0),
            child: Text(
              'NEW GOAL',
            ),
            onPressed: () => addNewGoal(context: context),
          )
        ],
      ),
      body: FutureBuilder<bool>(
          future: widget.type == GoalType.Long
              ? provider.fetchLongGoals()
              : provider.fetchShortGoals(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(child: CircularProgressIndicator());
            else if (snapshot.hasError || snapshot?.data == false)
              return Center(child: Text('Error displaying goals..'));
            return Consumer<Goal>(builder: (ctxt, goal, ch) {
              List<GoalItem> array;
              if (widget.type == GoalType.Long) {
                array = goal.longgoals;
              } else {
                array = goal.shortgoals;
              }
              array.sort((goalA, goalB) =>
                  goalA.lastChecked.compareTo(goalB.lastChecked));
              return ListView.builder(
                  itemBuilder: (ctx, index) =>
                      EachGoal(array[index], editDeleteCancel),
                  itemCount: array.length);
            });
          }),
    );
  }
}

//Cupertino Alert Dialog where user selects time and date

class NewGoalInputDialog extends StatefulWidget {
  final GoalType type;
  final GoalItem g;
  NewGoalInputDialog(this.type, this.g);
  @override
  NewGoalInputDialogState createState() => NewGoalInputDialogState();
}

class NewGoalInputDialogState extends State<NewGoalInputDialog> {
  static TextEditingController titleController;
  static TextEditingController descriptionController;
  String startDateHolder = '-_-';
  String endDateHolder = '-_-';
  static bool dateError = false;
  static DateTime startDate;
  static DateTime endDate;
  static final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    titleController = TextEditingController();
    titleController.text = widget.g?.title;
    descriptionController = TextEditingController();
    descriptionController.text = widget.g?.description;
    if (widget.g != null) {
      startDateHolder = widget.type == GoalType.Long
          ? DateFormat('EEE d/M/y').format(widget.g?.startDate)
          : DateFormat('EEE dd MMM HH:mm:ss').format(widget.g?.startDate);
      endDateHolder = widget.type == GoalType.Long
          ? DateFormat('EEE d/M/y').format(widget.g?.endDate)
          : DateFormat('EEE dd MMM HH:mm:ss').format(widget.g?.endDate);
    }
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> pickDateAndTime({bool isStartDate = true}) async {
      DateTime gTime;
      FocusScope.of(context).requestFocus(new FocusNode());
      if (widget.type == GoalType.Long) {
        gTime = await DatePicker.showDatePicker(
          context,
          minTime: DateTime.now().add(
            Duration(days: 7),
          ),
          currentTime: DateTime.now().add(Duration(days: 8)),
        );
        if (gTime != null)
          startDateHolder = DateFormat('EEE d/M/y').format(gTime);
      } else {
        gTime = await DatePicker.showDateTimePicker(context);
        if (gTime != null)
          isStartDate
              ? startDateHolder =
                  DateFormat('EEE dd MMM HH:mm:ss').format(gTime)
              : endDateHolder = DateFormat('EEE dd MMM HH:mm:ss').format(gTime);
      }
      setState(() {
        isStartDate ? startDate = gTime : endDate = gTime;
      });
    }

    return Form(
        key: formKey,
        child: Material(
          color: Colors.transparent,
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                SizedBox(height: 10),
                TextFormField(
                  controller: titleController,
                  validator: (str) {
                    if (str.isEmpty) {
                      return 'Field is Empty!';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    labelText: 'goal title...',
                    labelStyle: TextStyle(color: Colors.grey),
                    fillColor: Colors.grey.shade300,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 4),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  validator: (str) {
                    if (str.isEmpty) {
                      return 'Field is Empty!';
                    } else if (str.length <= 10) {
                      return 'Description is too short';
                    }
                    return null;
                  },
                  maxLines: 5,
                  controller: descriptionController,
                  decoration: InputDecoration(
                    filled: true,
                    alignLabelWithHint: true,
                    labelText: 'goal description...',
                    labelStyle: TextStyle(color: Colors.grey),
                    fillColor: Colors.grey.shade300,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 4),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () => pickDateAndTime(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Start',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(startDateHolder),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () => pickDateAndTime(isStartDate: false),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('End',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(endDateHolder),
                    ],
                  ),
                ),
                if (dateError)
                  Text('Enter correct dates in the above space',
                      style: TextStyle(color: Colors.red)),
              ])),
        ));
  }
}
