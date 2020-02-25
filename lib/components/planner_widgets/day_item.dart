import 'package:flutter/material.dart';
import '../../models/constants.dart';

class DayItem extends StatelessWidget {
  final DateTime datetime;
  final List<Todo> todos;
  const DayItem(this.datetime, {this.todos = const []});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical:2),
      child: Column(
        children: <Widget>[
          Container(
            child: Row(children: [
              Text(
                datetime.difference(DateTime.now()) < Duration(days: 1)
                    ? 'Today'
                    : datetime.difference(DateTime.now()) < Duration(days: 2)
                        ? 'Tomorrow'
                        : week[datetime.weekday],
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              Text(datetime.toIso8601String())
            ]),
          ),
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
