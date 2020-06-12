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

  //calculations for stats

  Future<void> fetchGoals() async {
    try {
      await fetchShortGoals();
      await fetchLongGoals();
    } catch (e) {
      print('Fetching goals for graphs: $e');
    }
  }

  //Experimental feature currently available for only short goals
  void markGoalAsRead(
      String id, int checkCount, List<DateTime> checkList) async {
    checkList.add(DateTime.now());
    List<String> newCheckList =
        checkList.map((e) => e.toIso8601String()).toList();
    await _db
        .collection("users/${_user.uid}/short_goals")
        .document(id)
        .updateData({
      'checkCount': checkCount + 1,
      'checkList': newCheckList,
    });
    notifyListeners();
  }

  //Short Goals Section
  Future<bool> fetchShortGoals() async {
    assert(_user != null);
    try {
      final snapshot =
          await _db.collection("users/${_user.uid}/short_goals").getDocuments();
      _short = snapshot.documents
          .map((doc) => GoalItem(
                id: doc.documentID,
                title: doc.data['title'],
                description: doc.data['description'],
                startDate: DateTime.parse(doc.data['startDate']),
                endDate: DateTime.parse(doc.data['endDate']),
                checkList: ((doc.data['checkList'] as List)
                        ?.map((element) => DateTime.parse(element))
                        ?.toList()) ??
                    [],
                checkCount: doc.data['checkCount'],
              ))
          .toList();
      notifyListeners();
    } catch (e) {
      print('Goal Provider: $e');
      return false;
    }
    return true;
  }

  void deleteShortGoal(String id) async => await _db
      .collection("users/${_user.uid}/short_goals")
      .document(id)
      .delete();

  Future<void> addShortGoal(
      {String id,
      @required DateTime startDate,
      @required DateTime endDate,
      @required String title,
      @required String description}) async {
    List<String> checkList = [];
    //Add a notification
    id == null
        ? await _db.collection("users/${_user.uid}/short_goals").add({
            'startDate': startDate.toIso8601String(),
            'endDate': endDate.toIso8601String(),
            'title': title,
            'checkCount': 0,
            'checkList': checkList,
            'description': description,
          })
        : await _db
            .collection("users/${_user.uid}/short_goals")
            .document(id)
            .updateData({
            'startDate': startDate.toIso8601String(),
            'endDate': endDate.toIso8601String(),
            'title': title,
            'description': description,
          });
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
                title: doc.data['title'],
                description: doc.data['description'],
                startDate: DateTime.parse(doc.data['startDate']),
                checkList: ((doc.data['checkList'] as List)
                        ?.map((element) => DateTime.parse(element))
                        ?.toList()) ??
                    [],
                checkpoints: (doc.data['checkpoints'] as List).map((ch) =>
                    LongGoalData(ch['order'], ch['checkpointDescription'],
                        ch['hoursCount'], ch['done'])).toList(),
              ))
          .toList();
      notifyListeners();
    } catch (e) {
      print('Long goal provider error: $e');
      return false;
    }
    return true;
  }

  void deleteLongGoal(String id) async => await _db
      .collection("users/${_user.uid}/long_goals")
      .document(id)
      .delete();

  Future<void> addLongGoal({
    String id,
    @required String title,
    @required String description,
    @required DateTime startDate,
    @required List<LongGoalData> checkpoints,
  }) async {
    List<String> checkList = [];

    //creating a new goal or update the goal if the ID already exists
    id == null
        ? await _db.collection("users/${_user.uid}/long_goals").add({
            'startDate': startDate.toIso8601String(),
            'title': title,
            'description': description,
            'checkList': checkList,
            'checkpoints': checkpoints
                .map((l) => {
                      'checkpointDescription': l.checkpointDescription,
                      'done': l.done,
                      'hoursCount': l.hoursCount,
                      'order': l.order,
                    })
                .toList(),
          })
        : await _db
            .collection("users/${_user.uid}/long_goals")
            .document(id)
            .updateData({
            'startDate': startDate.toIso8601String(),
            'title': title,
            'description': description,
            'checkpoints': checkpoints
                .map((l) => {
                      'checkpointDescription': l.checkpointDescription,
                      'done': l.done,
                      'hoursCount': l.hoursCount,
                      'order': l.order,
                    })
                .toList(),
            //TODO: checkpoint can only be added to,, so as to disallow bugs
          });
    notifyListeners();
  }
}
