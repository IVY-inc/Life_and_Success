import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/auth_error.dart';

class Auth extends ChangeNotifier {
  FirebaseUser _user;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<FirebaseUser> getUser() {
    return _auth.currentUser();
  }

  //Sign user up
  Future<void> signUp(String email, String password) async {
    try {
      final authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      _user = authResult.user;
      notifyListeners();
    } catch (e) {
      throw AuthError(e.toString());
    }
  }

  //Recover password
  Future<void> recoverPassword({String email}) async{
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw AuthError(e.toString());
    }
  }

  //log user in
  Future<void> logUserIn(String email, String password) async {
    try {
      _user = (await _auth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;
      notifyListeners();
    } catch (e) {
      throw AuthError(e.toString());
    }
  }

  Future<void> logOut() async {
    _user = null;

    await _auth.signOut();
    notifyListeners();
  }
}
