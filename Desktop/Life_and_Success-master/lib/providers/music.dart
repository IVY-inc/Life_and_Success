import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Music extends ChangeNotifier{
  final StorageReference storageReference = FirebaseStorage().ref().child('music');
}