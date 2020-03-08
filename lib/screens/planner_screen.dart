import 'dart:async';

import 'package:flutter/material.dart';

import '../components/planner_widgets/day_item.dart';

class PlannerScreen extends StatefulWidget {
  final Function back;
  PlannerScreen({this.back});
  @override
  _PlannerScreenState createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  List<Widget> _list;
  Timer timer;
  @override
  void initState() {
    updateList();
    timer = Timer.periodic(
        Duration(minutes: 2), (t) => setState(() => updateList()));
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  int pluspos;
  Widget addButton = Stack(
    alignment: Alignment.center,
    children: <Widget>[
      Column(
        children: <Widget>[
          Container(
              alignment: Alignment.centerLeft,
              height: 30,
              width: double.infinity,
              color: Colors.grey[300],
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('+ Add task'),
              )),
          Container(height: 20),
        ],
      ),
      Positioned(
          bottom: 0,
          child: FloatingActionButton(
            mini: true,
            child: Icon(Icons.add),
            onPressed: () {},
          )),
    ],
  );

  void updateList() {
    _list = List.generate(
      30,
      (int ix) => DayItem(
        ix,
        DateTime.now().add(
          Duration(
            hours: ix * 24,
          ),
        ),
      ),
    );
    for (int i = 0; i < _list.length; i++) {
      if ((_list[i] as DayItem).todos.isEmpty) {
        pluspos = i + 1;
        _list.insert(pluspos, addButton);
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => widget.back(isBackKey: true),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => widget.back(isBackKey: true)),
          elevation: 0,
          title: Text('Planner'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: ListView.separated(
            itemBuilder: (ctx, i) => _list[i],
            itemCount: _list.length,
            separatorBuilder: (_, i) => i == pluspos - 1 || i == pluspos
                ? Container(height: 4)
                : Divider(),
          ),
        ),
      ),
    );
  }
}
