import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/constants.dart';

class DayItem extends StatelessWidget {
  final int ix;
  final DateTime datetime;
  final List<Todo> todos;
  const DayItem(this.ix,this.datetime, {this.todos = const []});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical:2),
      child: Column(
        children: <Widget>[
          Row(children: [
            Text(
              ix==0
                  ? 'Today'
                  : ix==1
                      ? 'Tomorrow'
                      : week[datetime.weekday],
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            SizedBox(width:10),
            Text(DateFormat('EEE MMM d').format(datetime),),
          ]),
          for (int i = 0; i < todos.length; i++) ...[
            TodoBuilder(todos[i]),
            Divider(),
          ]
        ],
      ),
    );
  }
}

class TodoBuilder extends StatelessWidget {
  final Todo todo;
  TodoBuilder(this.todo);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Checkbox(value: todo.done, onChanged: (v) => todo.done = v),
        SizedBox(width: 20),
        Text(todo.desc),
      ],
    );
  }
}

class Todo {
  String desc;
  bool done = false;
  DateTime date;
}
