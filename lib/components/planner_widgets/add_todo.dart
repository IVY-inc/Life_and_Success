import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:life_and_success/helper/notification_helper.dart';
import 'package:life_and_success/main.dart';
import 'package:provider/provider.dart';

import '../../data/db.dart';

class AddTodo extends StatefulWidget {
  final DateTime date;
  const AddTodo(this.date, {Key key}) : super(key: key);

  @override
  _AddTodoState createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  TextEditingController _descController;
  DateTime time;
  GlobalKey<FormState> _formKey;
  @override
  void initState() {
    _formKey = GlobalKey();
    _descController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 40),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Create a new Todo',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 26,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Container(
                width: MediaQuery.of(context).size.width * 0.7,
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: TextFormField(
                    controller: _descController,
                    decoration:
                        InputDecoration(hintText: 'Enter TODO description'),
                    validator: (val) {
                      if (val.isEmpty) {
                        return 'This field cannot be empty';
                      }
                      return null;
                    })),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: InputDecorator(
                      decoration: InputDecoration(enabled: false),
                      isFocused: false,
                      child: Text(
                        DateFormat('EEE MMM d').format(widget.date),
                      )),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: InkWell(
                      onTap: () async {
                        final date =
                            await DatePicker.showTime12hPicker(context);
                        if (date != null) setState(() => time = date);
                      },
                      child: InputDecorator(
                          decoration: InputDecoration(),
                          child: Text(time == null
                              ? 'TODO Time'
                              : DateFormat('HH:mm:ss').format(time)))),
                ),
              ],
            ),
            ElevatedButton(
              child: Text('Create Todo'),
              onPressed: () async {
                if (!_formKey.currentState.validate()) {
                  return;
                } else if (time == null) {
                  showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                            title: Text('Time must be provided'),
                          ));
                  return;
                } else {
                  DateTime t = widget.date.add(Duration(
                      hours: time.hour,
                      minutes: time.minute,
                      seconds: time.second));
                  int id = await Provider.of<MyDatabase>(context, listen: false)
                      .insertTodo(Todo(
                          date: t.toIso8601String(),
                          desc: _descController.text.trim()));
                  scheduleNotification(
                      plugin: flutterLocalNotificationsPlugin,
                      body: _descController.text.trim(),
                      id: id,
                      scheduledTime: t);
                  Navigator.of(context).pop();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
