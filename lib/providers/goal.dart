import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseUser;
import '../models/constants.dart';

class Goal extends ChangeNotifier {
  final FirebaseUser _user;
  Goal(this._user);
  List<GoalItem> _short = [];
  List<GoalItem> _long = [];
  
  List<GoalItem> get shortgoals => [..._short];
  List<GoalItem> get longgoals => [..._long];
}
