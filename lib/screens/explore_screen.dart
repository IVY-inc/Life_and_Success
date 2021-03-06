import 'package:flutter/material.dart';
import './explore/goals/goal_planner_screen.dart';
import './explore/books/books_screen.dart';

//Dealing with static and final constructors and stuffs

Function gBack;
Map<String, Widget> routes = {
  '/goalplanner': GoalPlannerScreen(back: gBack, nPayload: ExplorerScreen.np),
  '/books': BooksScreen(back: gBack),
};

class ExplorerScreen extends StatefulWidget {
  static const routeName = '/explorer';
  final String explorerRoute;
  final Function back;
  static String np;
  final String notificationPayload;

  ExplorerScreen({this.explorerRoute, this.back, this.notificationPayload}) {
    gBack = back;
    np = notificationPayload;
  }

  @override
  _ExplorerScreenState createState() => _ExplorerScreenState();
}

class _ExplorerScreenState extends State<ExplorerScreen> {
  String nav = '/goalplanner';
  @override
  Widget build(context) {
    String navi = widget.explorerRoute;
    if (navi != null && navi != "") {
      nav = navi;
    }

    ///Begin of the notificationPayload handling.. it may or may not be received
    ///If received.. go to the goal screen and push the [notificationPayload] which will be referred to as np to allow for static calls
    /// forward.. do not bother about the result of the explorerRoute
    ///If not received obey the explorerRoute anyways
    if (widget.notificationPayload != null) {
      print('Explorer screen line 42');
      nav = '/goalplanner';
    }
    return WillPopScope(
        onWillPop: () => gBack != null ? gBack(isBackKey: true) : null,
        child: routes[nav]);
  }
}
