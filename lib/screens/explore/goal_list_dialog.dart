import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import '../../models/constants.dart';
import '../../providers/goal.dart';

class GoalListDialog extends StatelessWidget {
  final GoalType type;
  GoalListDialog({@required this.type});
  addNewGoal({@required BuildContext context}) async {
    bool hasError = false;
    final provider = Provider.of<Goal>(context, listen: false);
    await showCupertinoDialog(
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
                        type == GoalType.Long
                            ? provider.addShortGoal(
                                time: NewGoalInputDialogState.goalTime,
                                title: NewGoalInputDialogState
                                    .titleController.text,
                                description: NewGoalInputDialogState
                                    .descriptionController.text)
                            : provider.addLongGoal(
                                time: NewGoalInputDialogState.goalTime,
                                title: NewGoalInputDialogState
                                    .titleController.text,
                                description: NewGoalInputDialogState
                                    .descriptionController.text);
                      } catch (e) {
                        print(e);
                        hasError = true;
                      }
                      Navigator.of(ctx).pop();
                    }),
              ],
              title: Text(
                  'Set ${type == GoalType.Long ? 'a Lifetime' : 'an Instant'} goal'),
              content: NewGoalInputDialog(type),
            ));
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

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Goal>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
            '${type == GoalType.Long ? 'LIFETIME GOALS' : 'INSTANT GOALS'}'),
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
          future: type == GoalType.Long
              ? provider.fetchLongGoals()
              : provider.fetchShortGoals(),
          builder: (ctx, snapshot) {
            if (snapshot.hasError || snapshot?.data == false)
              return Center(child: Text('Error displaying goals..'));
            else if (snapshot.connectionState == ConnectionState.waiting)
              return Center(child: CircularProgressIndicator());
            return Consumer<Goal>(builder: (ctxt, goal, ch) {
              List<GoalItem> array;
              if (type == GoalType.Long) {
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
        dateController.text = DateFormat('EEE d/M/y').format(gTime);
      } else {
        gTime = await DatePicker.showDateTimePicker(context);
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
                      suffixIcon: GestureDetector(
                        child: Icon(Icons.calendar_today),
                        onTap: () => pickDateAndTime(),
                      ),
                    )),
              ])),
        ));
  }
}