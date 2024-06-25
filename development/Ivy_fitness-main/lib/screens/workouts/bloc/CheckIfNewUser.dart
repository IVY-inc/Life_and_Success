import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_flutter/screens/workouts/bloc/workouts_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final FirebaseFirestore firestore;

  UserBloc(this.firestore) : super(UserInitial());

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    if (event is CheckIfNewUserEvent) {
      try {
        // Check if the user document exists
        DocumentSnapshot userDoc = await firestore.collection('users').doc(event.userId).get();

        if (userDoc.exists) {
          // User exists
          yield UserExisting();
        } else {
          // User does not exist
          yield UserNew();
        }
      } catch (e) {
        yield UserError(e.toString());
      }
    }
  }
}