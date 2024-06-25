import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_flutter/screens/workouts/bloc/CheckIfNewUser.dart';
import 'package:fitness_flutter/screens/workouts/bloc/workouts_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserCheckPage extends StatelessWidget {
  final String userId;

  UserCheckPage({required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserBloc(FirebaseFirestore.instance)..add(CheckIfNewUserEvent(uid: '') as UserEvent),
      child: Scaffold(
        appBar: AppBar(title: Text('User Check')),
        body: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserInitial) {
              return Center(child: CircularProgressIndicator());
            } else if (state is UserNew) {
              return Center(child: Text('Welcome! Please input your health data.'));
            } else if (state is UserExisting) {
              return Center(child: Text('Это ваши тренировки на сегодня.'));
            } else if (state is UserError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return Container();
          },
        ),
      ),
    );
  }
}
