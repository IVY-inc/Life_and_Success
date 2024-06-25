import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: unused_import
import 'package:firebase_auth/firebase_auth.dart';
// ignore: unused_import
import 'package:fitness_flutter/core/extensions/exceptions.dart';
// ignore: unused_import
import 'package:flutter/services.dart';

class DB_Service {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> checkIfUserExists(String userId) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();
      return userDoc.exists;
    } catch (e) {
      print("Error checking user existence: $e");
      return false;
    }
  }
}
