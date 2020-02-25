import 'package:flutter/material.dart';

import '../components/planner_widgets/day_item.dart';

class PlannerScreen extends StatelessWidget {
  bool added = false;
  int pluspos;
  Widget addButton=Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(alignment: Alignment.centerLeft, height: 30,width:double.infinity,color: Colors.grey[300], child: Text('+ Add task')),
            Container(height: 20),
          ],
        ),
        Positioned(bottom:0,child:
        FloatingActionButton(mini: true,
          child: Icon(Icons.add),
          onPressed: () {},
        )
        ),
      ],
    );

  List<Widget> _list = List.generate(30,
      (int ix) => DayItem(DateTime.now().add(Duration(days: ix, minutes: 1))));
  void updateList() {
    for (int i = 0; i < _list.length; i++) {
      if ((_list[i] as DayItem).todos.isEmpty &&!added) {
        pluspos = i + 1;
        _list.insert(
          pluspos,
          addButton
        );
        added = true;
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if(!added)updateList();
    return Scaffold(
      appBar: AppBar(
        title: Text('Planner'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical:8.0),
        child: ListView.separated(
          itemBuilder: (ctx, i) => _list[i],
          itemCount: _list.length,
          separatorBuilder: (_,i) => i==pluspos-1||i==pluspos?Container(height:4):Divider(),
        ),
      ),
    );
  }
}
