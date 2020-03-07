import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class GoalPlannerScreen extends StatelessWidget {
  static const routeName = '/goalplanner';
  @override
  Widget build(BuildContext context) {
    final radius = MediaQuery.of(context).size.width/2;
    return Scaffold(
      appBar: AppBar(
        title: Text('Goals'),
      ),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          //Alarm icon here
          Icon(Icons.alarm),
          Text('Lorem ipsum dolor sit amet consectetur adipiscing elit'),
          Row(children: <Widget>[
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      Text('LIFETIME GOALS',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          )),
                      CircularPercentIndicator(
                        lineWidth: 10.0,
                        radius: radius,
                        percent: 20 / 80,
                        center: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('20',
                                style: Theme.of(context)
                                    .textTheme
                                    .display1
                                    .copyWith(fontWeight: FontWeight.bold)),
                            Text('/80 goals')
                          ],
                        ),
                        progressColor: Colors.blueAccent,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Card(),
              //     child: CircularPercentIndicator(
              //lineWidth: 6.0,
              //       radius: double.infinity,
              //       center: Text('80%'),
              //       progressColor: Colors.pink,
              //     ),
            ),
          ]),
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
