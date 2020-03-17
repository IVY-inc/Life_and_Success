import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseUser;
import '../models/constants.dart';

class Goal extends ChangeNotifier {
  final FirebaseUser _user;
  final Firestore _db = Firestore.instance;

  Goal(this._user);

  List<GoalItem> _short = [];
  List<GoalItem> _long = [];

  List<GoalItem> get shortgoals => [..._short];
  List<GoalItem> get longgoals => [..._long];

  //Short Goals Section
  Future<bool> fetchShortGoals() async {
    assert(_user != null);
    // try {
      final snapshot =
          await _db.collection("users/${_user.uid}/short_goals").getDocuments();
      _short = snapshot.documents
          .map((doc) => GoalItem(
                id: doc.documentID,
                time: DateTime.parse(doc.data['time']),
                title: doc.data['title'],
                done: doc.data['done'] as bool,
                description: doc.data['description'],
              ))
          .toList();
      notifyListeners();
    // } catch (e) {
    //   print('Goal Provider: $e');
    //   return false;
    // }
    return true;
  }

  Future<void> addShortGoal(
      {@required DateTime time,
      @required String title,
      @required String description,
      bool done = false}) async {
    final request = await _db.collection("users/${_user.uid}/short_goals").add({
      'time': time.toIso8601String(),
      'title': title,
      'description': description,
      'done': done,
    });
    print(request.documentID);
    notifyListeners();
  }

  //Long Goals Section
  Future<bool> fetchLongGoals() async {
    assert(_user != null);
    try {
      final snapshot =
          await _db.collection("users/${_user.uid}/long_goals").getDocuments();
      _long = snapshot.documents
          .map((doc) => GoalItem(
                id: doc.documentID,
                time: DateTime.parse(doc.data['time']),
                title: doc.data['title'],
                done: doc.data['done'],
                description: doc.data['description'],
              ))
          .toList();
      notifyListeners();
    } catch (e) {
      print('Long goal provider error: $e');
      return false;
    }
    return true;
  }

  Future<void> addLongGoal(
      {@required DateTime time,
      @required String title,
      @required String description,
      bool done = false}) async {
    await _db.collection("users/${_user.uid}/long_goals").add({
      'time': time.toIso8601String(),
      'title': title,
      'description': description,
      'done': done,
    });
    notifyListeners();
  }
}
