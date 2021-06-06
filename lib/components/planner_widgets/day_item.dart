import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:life_and_success/data/db.dart';
import '../../models/constants.dart';
import 'add_todo.dart';

class DayItem extends StatelessWidget {
  final int ix;
  final DateTime datetime;
  final List<Todo> todos;
  DayItem(this.ix, this.datetime, {List<Todo> todos})
      : this.todos = todos ?? [];
  void showAddTodo(DateTime datetime, BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (ctx) => AddTodo(datetime),
        isScrollControlled: true);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2),
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () => showAddTodo(datetime, context),
            child: Row(children: [
              Text(
                ix == 0
                    ? 'Today'
                    : ix == 1
                        ? 'Tomorrow'
                        : week[datetime.weekday],
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              SizedBox(width: 10),
              Text(
                DateFormat('EEE MMM d').format(datetime),
              ),
            ]),
          ),
          if (todos.isNotEmpty) SizedBox(height: 5),
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
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Expanded(
            child:
                Text(todo.desc, style: TextStyle(fontWeight: FontWeight.bold))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(DateFormat(DateFormat.HOUR24_MINUTE_SECOND)
                .format(DateTime.parse(todo.date))),
          ),
        ),
        Align(
            alignment: Alignment.centerRight,
            child: Icon(todo.done ? Icons.done : Icons.more_horiz,
                color: todo.done ? Colors.green : Colors.amber))
      ],
    );
  }
}
