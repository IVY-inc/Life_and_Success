import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

enum GoalType { Short, Long }

class GoalPlannerScreen extends StatelessWidget {
  final Function back;
  GoalPlannerScreen({this.back});
  static const routeName = '/goalplanner';
  @override
  Widget build(BuildContext context) {
    final radius = MediaQuery.of(context).size.width / 2 - 60;
    Widget circularIndicators({
      double percent,
      Widget child,
      Color color,
    }) {
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

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => back(isBackKey: true)),
        title: Text('Goals'),
      ),
      body: SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
            Widget>[
          //Alarm icon here
          SizedBox(height: 10),
          Icon(Icons.alarm),
          SizedBox(height: 10),
          Text('Your Goal Planner',
              style: Theme.of(context).textTheme.body2.copyWith(fontSize: 16)),
          SizedBox(height: 10),
          Text('Lorem ipsum dolor sit amet consectetur adipiscing elit'),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: GestureDetector(
                    onTapUp: (_) => Navigator.of(context).push(
                      new MaterialPageRoute(
                        builder: (BuildContext context) =>
                            GoalListDialog(type: GoalType.Long),
                        fullscreenDialog: true,
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
                            Text('LIFETIME GOALS',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                )),
                            circularIndicators(
                              percent: 20 / 80,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text('20',
                                      style: Theme.of(context)
                                          .textTheme
                                          .display1
                                          .copyWith(
                                              fontWeight: FontWeight.bold)),
                                  Text('/80 goals')
                                ],
                              ),
                              color: Colors.blueAccent,
                            ),
                            cardBottom('Lifetime goals', '80 goals'),
                            cardBottom('Achieved', '20 goals'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            'SHORT TERM GOALS',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          circularIndicators(
                              percent: 20 / 80,
                              child: Text('80%',
                                  style: Theme.of(context)
                                      .textTheme
                                      .display1
                                      .copyWith(fontWeight: FontWeight.bold)),
                              color: Colors.pink),
                          cardBottom('Short term goals', '100%'),
                          cardBottom('Achieved', '80%'),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ]),
          ),
          SizedBox(height: 20),
          Text(
            'Your Lifetime goals',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          GoalSummaryItems(Icons.alarm, 'All lifetime goals', '80'),
          GoalSummaryItems(Icons.alarm, 'Monthly Milestones achieved', '50/92'),
          GoalSummaryItems(Icons.alarm, 'Daily Milestones achieved', '4/7'),
          GoalSummaryItems(Icons.alarm, 'Weekly milestones achieved', '4/7'),
          GoalSummaryItems(Icons.alarm, 'Monthly Milestones achieved', '50/92'),
          GoalSummaryItems(Icons.alarm, 'Daily Milestones achieved', '4/7'),
        ]),
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

class GoalListDialog extends StatelessWidget {
  final GoalType type;
  GoalListDialog({@required this.type});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${type == GoalType.Long ? 'LIFETIME GOALS' : 'SHORT TERM GOALS'}'),  
        actions: <Widget>[
          FlatButton(
            child: Text(
                'ADD NEW ${type == GoalType.Long ? 'LONG' : 'SHORT'} GOAL'),
            onPressed: () {
              // Link goal provider method to add goal here
            },
          )
        ],
      ),
      body:FutureBuilder(future:null,builder:(ctx,snapshot)=>Container() ),
    );
  }
}
