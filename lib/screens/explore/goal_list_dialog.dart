import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import '../../models/constants.dart';
import '../../providers/goal.dart';

class GoalListDialog extends StatefulWidget {
  final GoalType type;
  GoalListDialog({@required this.type});

  @override
  _GoalListDialogState createState() => _GoalListDialogState();
}

class _GoalListDialogState extends State<GoalListDialog> {
  addNewGoal({@required BuildContext context}) async {
    bool hasError = false, taskdone = false;
    final provider = Provider.of<Goal>(context, listen: false);
    if (await showCupertinoDialog<bool>(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
              actions: <Widget>[
                CupertinoDialogAction(
                    child: Text('Add Goal'),
                    onPressed: () {
                      if (!NewGoalInputDialogState.formKey.currentState
                          .validate()) {
                        return;
                      }
                      try {
                        widget.type == GoalType.Long
                            ? provider.addLongGoal(
                                time: NewGoalInputDialogState.goalTime,
                                title: NewGoalInputDialogState
                                    .titleController.text,
                                description: NewGoalInputDialogState
                                    .descriptionController.text)
                            : provider.addShortGoal(
                                time: NewGoalInputDialogState.goalTime,
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
              ],
              title: Text(
                  'Set ${widget.type == GoalType.Long ? 'a Lifetime' : 'an Instant'} goal'),
              content: NewGoalInputDialog(widget.type),
            ))??false)
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
    setState(() {});
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
              return ListView.builder(
                  itemBuilder: (ctx, index) =>
                      ListTile(title: Text(array[index].title)),
                  itemCount: array.length);
            });
          }),
    );
  }
}

//Cupertino Alert Dialog where user selects time and date

class NewGoalInputDialog extends StatefulWidget {
  final GoalType type;
  NewGoalInputDialog(this.type);
  @override
  NewGoalInputDialogState createState() => NewGoalInputDialogState();
}

class NewGoalInputDialogState extends State<NewGoalInputDialog> {
  static TextEditingController titleController;
  static TextEditingController descriptionController;
  static TextEditingController dateController;
  static DateTime goalTime;
  static final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    titleController = TextEditingController();
    descriptionController = TextEditingController();
    dateController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> pickDateAndTime() async {
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
          dateController.text = DateFormat('EEE d/M/y').format(gTime);
      } else {
        gTime = await DatePicker.showDateTimePicker(context);
        if (gTime != null)
          dateController.text = DateFormat('EEE dd MMM HH:mm:ss').format(gTime);
      }
      setState(() {
        goalTime = gTime;
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
                SizedBox(height: 20),
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
                TextFormField(
                    validator: (str) {
                      if (str.isEmpty || goalTime == null) {
                        return 'Please, select time and date';
                      }
                      return null;
                    },
                    onTap: () async => await pickDateAndTime(),
                    controller: dateController,
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.calendar_today),
                    )),
              ])),
        ));
  }
}
