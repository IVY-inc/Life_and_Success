import 'package:flutter/material.dart';
import 'package:life_and_success/screens/explore/goal_planner_screen.dart';

Map<String,Widget>routes = {
  '/goalplanner':GoalPlannerScreen(),
};
class ExplorerScreen extends StatefulWidget {
  static const routeName = '/explorer';
  final String payload;
  ExplorerScreen({this.payload});
  @override
  _ExplorerScreenState createState() => _ExplorerScreenState();
}

class _ExplorerScreenState extends State<ExplorerScreen> {
  String nav = '/goalplanner';
  @override
  void didChangeDependencies() {
    String navi = widget.payload;
    if(navi!=null&&navi!=""){
      nav = navi;
    }
    super.didChangeDependencies();
  }
  @override
  Widget build(context){
    return routes[nav];
  }
}