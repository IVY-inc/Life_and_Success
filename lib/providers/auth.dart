import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/auth_error.dart';
import '../models/constants.dart';

class Auth extends ChangeNotifier {
  FirebaseUser _user;
  final Firestore _db = Firestore();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<FirebaseUser> getUser() async{
    _user = await _auth.currentUser();
    return _user;
  }
  FirebaseUser get user{
    return _user;
  }

  Future<Gender> getUserGender() async{
   final gender = await _db.collection("users").document(_user.uid).get().then((snapshot)=>snapshot['gender']);
   if(gender==1){
     return Gender.Female;
   }else{
     return Gender.Male;
   }
  }
  Future<void> setUserGender(Gender g) async{
    int genderCode = 0;
    if(g==Gender.Female){
      genderCode = 1;
    }
    try{
    await _db.collection("users").document(_user.uid).setData({'gender':genderCode});
    }catch(e){
      print(e);
    }
  }

  Future<void> updateUsername(String username) async{
    UserUpdateInfo update = UserUpdateInfo();
    try{
    update.displayName = username;
    await _user.updateProfile(update);
    }catch(e){
      print(e);
    }
  }
  //Sign user up
  Future<void> signUp(String email, String password, Gender g) async {
    try {
      final authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      _user = authResult.user;
      if(_user!=null){
        setUserGender(g);
      }
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
