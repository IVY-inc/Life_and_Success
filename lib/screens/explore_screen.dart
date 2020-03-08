import 'package:flutter/material.dart';
import 'package:life_and_success/screens/explore/goal_planner_screen.dart';

//Dealing with static and final constructors and stuffs

Function gBack;
Map<String, Widget> routes = {
  '/goalplanner': GoalPlannerScreen(back: gBack),
};

class ExplorerScreen extends StatefulWidget {
  static const routeName = '/explorer';
  final String payload;
  final Function back;

  ExplorerScreen({this.payload, this.back}) {
    gBack = back;
  }

  @override
  _ExplorerScreenState createState() => _ExplorerScreenState();
}

class _ExplorerScreenState extends State<ExplorerScreen> {
  String nav = '/goalplanner';
  @override
  void didChangeDependencies() {
    String navi = widget.payload;
    if (navi != null && navi != "") {
      nav = navi;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(context) {
    return WillPopScope(
        onWillPop: () => gBack != null ? gBack(isBackKey: true) : null,
        child: routes[nav]);
  }
}
