import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/planner_widgets/add_todo.dart';
import '../components/planner_widgets/day_item.dart';
import '../data/db.dart';

class PlannerScreen extends StatefulWidget {
  final Function back;
  final String payload;
  PlannerScreen({this.back, this.payload});
  @override
  _PlannerScreenState createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  List<Widget> _list;
  DateTime startOfToday() => DateTime.now().subtract(Duration(
      hours: DateTime.now().hour,
      minutes: DateTime.now().minute,
      seconds: DateTime.now().second));
  @override
  void initState() {
    updateList();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  int pluspos = 1;
  Widget addButton(BuildContext context) => Stack(
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
                onPressed: () => showModalBottomSheet(
                    context: context,
                    builder: (ctx) => AddTodo(startOfToday()),isScrollControlled: true),
              )),
        ],
      );

  void updateList({List<Todo> data}) {
    final Map<int, List<Todo>> record = {};
    if (data != null) {
      data.forEach((element) {
        try {
          final date = DateTime.parse(element.date);

          if (date.isAfter(startOfToday())) {
            int d = date.difference(DateTime.now()).inDays;
            if (!record.containsKey(d)) {
              record[d] = [];
            }
            record[d].add(element);
          }
        } catch (_) {}
      });
    }
    _list = List.generate(
      30,
      (int ix) => DayItem(
          ix,
          DateTime.now()
              .subtract(Duration(
                  hours: DateTime.now().hour,
                  minutes: DateTime.now().minute,
                  seconds: DateTime.now().second))
              .add(
                Duration(
                  hours: ix * 24,
                ),
              ),
          todos: record[ix]),
    );
    _list.insert(1, addButton(context));
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    Provider.of<MyDatabase>(context, listen: false)
        .watchAllTodos()
        .listen((data) {
      updateList(data: data);
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => widget.back(isBackKey: true),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
