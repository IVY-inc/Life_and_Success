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
    try{
    await fetchShortGoals();
    await fetchLongGoals();
    }catch(e){
      print('Fetching goals for graphs: $e');
    }
  }
  //Experimental feature currently available for only short goals
  void markGoalAsRead(String id, int checkCount) async {
    await _db
        .collection("users/${_user.uid}/short_goals")
        .document(id)
        .updateData({
      'checkCount': checkCount + 1,
      'lastChecked': DateTime.now().toIso8601String(),
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
              lastChecked: DateTime.parse(doc.data['lastChecked']),
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
    //Add a notification
    id == null
        ? await _db.collection("users/${_user.uid}/short_goals").add({
            'startDate': startDate.toIso8601String(),
            'endDate': endDate.toIso8601String(),
            'title': title,
            'checkCount': 0,
            'lastChecked':
                DateTime.now().subtract(Duration(days: 1)).toIso8601String(),
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
      final snapshot = await _db
          .collection("users/${_user.uid}/long_goals")
          .getDocuments();
      _long = snapshot.documents
          .map((doc) => GoalItem(
                id: doc.documentID,
                title: doc.data['title'],
                description: doc.data['description'],
                startDate: DateTime.parse(doc.data['startDate']),
                lastChecked: DateTime.parse(doc.data['lastChecked']),
                checkpoints: doc.data['checkpoints'] as List<LongGoalData>,
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
  Future<void> addLongGoal(
      {String id,
      @required String title,
      @required String description,
      @required DateTime startDate,
      @required List<LongGoalData> checkpoints,

      }) async {
        //creating a new goal or update the goal if the ID already exists
    id == null
        ? await _db.collection("users/${_user.uid}/long_goals").add({
            'startDate': startDate.toIso8601String(),
            'title': title,
            'description': description,
            'lastChecked':DateTime.now().subtract(Duration(days: 1)).toIso8601String(),
            'checkpoints': checkpoints,
          })
        : await _db
            .collection("users/${_user.uid}/long_goals")
            .document(id)
            .updateData({
            'startDate': startDate.toIso8601String(),
            'title': title,
            'description': description,
            'checkpoints': checkpoints, 
            //TODO: checkpoint can only be added to,, so as to disallow bugs
          });
    notifyListeners();
  }
}
