import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

import '../../providers/goal.dart';
import './goal_list_dialog.dart';
import '../../models/constants.dart';

//checker for miscalls
var oldID;

class GoalPlannerScreen extends StatefulWidget {
  final Function back;
  final String nPayload;
  //TODO: check if [nPayload] value persists when class is reopened
  GoalPlannerScreen({this.back, this.nPayload});
  static const routeName = '/goalplanner';

  @override
  _GoalPlannerScreenState createState() => _GoalPlannerScreenState();
}

class _GoalPlannerScreenState extends State<GoalPlannerScreen> {
  //Function called answering to Notification call

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    //At this point check if app was called by a Notification..
    //Update database
    //[done] field to true by default and display a Dialog to user
    if (widget.nPayload != null && widget.nPayload != '') {
      bool markAsDone = true;
      List<String> splitted = widget.nPayload.split('||');
      var id = splitted[0];
      var title = splitted[1];
      var description = splitted[2];
      if (oldID != null) {
        return;
      } else {
        oldID = id;
      }
      var done = await showCupertinoDialog<bool>(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: Text(title),
          content: RichText(
              text: TextSpan(text: description, children: [
            TextSpan(
              text: '\nThis goal has been marked as ',
            ),
            TextSpan(
                text: 'DONE', style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: 'by default. Agree?')
          ])),
          insetAnimationCurve: Curves.bounceIn,
          insetAnimationDuration: const Duration(milliseconds: 300),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Icon(CupertinoIcons.clear),
              onPressed: () {
                markAsDone = false;
                Navigator.of(ctx).pop(markAsDone);
              },
            ),
            CupertinoDialogAction(
              onPressed: () => Navigator.of(ctx).pop(markAsDone),
              child: Icon(CupertinoIcons.check_mark),
              isDefaultAction: true,
            )
          ],
        ),
      );
      if (done) Provider.of(context, listen: false).markGoalAsDone(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final radius = MediaQuery.of(context).size.width / 2 - 60;

    //Refactor Widgets
    //********************** */

    Widget circularIndicators({double percent, Widget child, Color color}) {
      return CircularPercentIndicator(
        lineWidth: 12.0,
        radius: radius,
        percent: percent,
        center: child,
        progressColor: color,
        circularStrokeCap: CircularStrokeCap.round,
      );
    }

    Widget cardBottom(String t1, String v1) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(t1),
              Text(
                v1,
                style: TextStyle(color: Colors.grey),
              )
            ]),
      );
    }

    Widget goalCardRefactor({
      @required GoalType type,
      @required String heading,
      @required Widget circularIndicator,
      @required Widget cardBottom1,
      @required Widget cardBottom2,
    }) {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: GestureDetector(
            onTapUp: (_) => Navigator.of(context).push(
              new MaterialPageRoute(
                builder: (BuildContext context) => GoalListDialog(type: type),
                fullscreenDialog: true,
                maintainState: true,
              ),
            ),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    Text(heading,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        )),
                    circularIndicator,
                    cardBottom1,
                    cardBottom2,
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    ///APP'S BODY.. ENTRY POINT OF SCREEN
    ///
    ///
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => widget.back(isBackKey: true)),
        title: Text('Goals'),
      ),
      body: RefreshIndicator(
        onRefresh: () => Provider.of<Goal>(context, listen: false).fetchGoals(),
        child: SingleChildScrollView(
          child: FutureBuilder(
              future: Provider.of<Goal>(context, listen: false).fetchGoals(),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(child: CircularProgressIndicator());
                else if (snapshot.hasError || snapshot?.data == false)
                  return Center(child: Text('Error displaying goals..'));
                return Consumer<Goal>(
                  builder: (ctx, goal, ch) {
                    //short goals
                    int checked = 0;
                    int todayChecked = 0;
                    int totalDays = 0;
                    goal.shortgoals.forEach((goalItem) {
                      checked += goalItem.checkCount;
                      if (goalItem.lastChecked.month == DateTime.now().month &&
                          goalItem.lastChecked.day == DateTime.now().day)
                        todayChecked += 1;
                      totalDays += goalItem.endDate
                          .difference(goalItem.startDate)
                          .inDays;
                      if ((goalItem.endDate
                                  .difference(goalItem.startDate)
                                  .inHours %
                              24) >=
                          11) totalDays += 1;
                    });
                    return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          //Alarm icon here
                          SizedBox(height: 10),
                          Icon(Icons.alarm),
                          SizedBox(height: 10),
                          Text('Your Goal Planner',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(fontSize: 16)),
                          SizedBox(height: 10),
                          Text(
                              'Lorem ipsum dolor sit amet consectetur adipiscing elit'),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(children: <Widget>[
                              goalCardRefactor(
                                type: GoalType.Long,
                                heading: 'LIFETIME GOALS',
                                circularIndicator: circularIndicators(
                                  //here
                                  percent: 20 / 80,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      //here
                                      Text('20',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4
                                              .copyWith(
                                                  fontWeight: FontWeight.bold)),
                                      Text('/80 goals')
                                    ],
                                  ),
                                  color: Colors.blueAccent,
                                ),
                                cardBottom1:
                                    cardBottom('Lifetime goals', '80 goals'),
                                cardBottom2: cardBottom('Achieved', '20 goals'),
                              ),
                              goalCardRefactor(
                                cardBottom1: cardBottom('Short term goals',
                                    '${goal.shortgoals.length}'),
                                cardBottom2: cardBottom('Achieved',
                                    '${totalDays == 0 ? 0 : min(99, (checked * 100 / totalDays).round())}%'),
                                type: GoalType.Short,
                                heading: 'SHORT TERM GOALS',
                                circularIndicator: circularIndicators(
                                    percent: (checked == 0 && totalDays == 0)
                                        ? 0.0
                                        : checked / totalDays,
                                    child: Text(
                                        '${totalDays == 0 ? 0 : min(99, (checked * 100 / totalDays).round())}%',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4
                                            .copyWith(
                                                fontWeight: FontWeight.bold)),
                                    color: Colors.pink),
                              ),
                            ]),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Your Lifetime goals',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          GoalSummaryItems(
                              Icons.alarm, 'All lifetime goals', '80'),
                          GoalSummaryItems(Icons.alarm,
                              'Daily Milestones achieved', '$todayChecked/${goal.shortgoals.length}'),
                          GoalSummaryItems(
                              Icons.alarm, 'Weekly milestones achieved', '4/7'),
                          GoalSummaryItems(Icons.alarm,
                              'Monthly Milestones achieved', '50/92'),
                        ]);
                  },
                );
              }),
        ),
      ),
    );
  }
}

///
///Helper classes {more like components or widgets used within this screen}
///
class GoalSummaryItems extends StatelessWidget {
  final IconData icon;
  final String description;
  final String trail;
  GoalSummaryItems(this.icon, this.description, this.trail);
  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Icon(
          icon,
        ),
        title: Text(description),
        trailing: Text(trail));
  }
}
