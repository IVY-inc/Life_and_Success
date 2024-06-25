import 'dart:async';
import 'dart:math';
import 'package:bloc/bloc.dart';
// ignore: unused_import
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_flutter/core/service/db_service.dart';
import 'package:fitness_flutter/data/workout_data.dart';
import 'package:meta/meta.dart';

part 'workouts_event.dart';
part 'workouts_state.dart';

class WorkoutsBloc extends Bloc<WorkoutsEvent, WorkoutsState> {
  final dB_Service = DB_Service();
  WorkoutsBloc() : super(WorkoutsInitial());

  @override
  Stream<WorkoutsState> mapEventToState(WorkoutsEvent event) async* {
    if (event is CheckIfNewUserEvent) {
      bool isNewUser = await dB_Service.checkIfUserExists(event.uid);
      if (isNewUser) {
        yield NewUserState();
        // ignore: dead_code
      } else {
        add(GenerateWorkoutsEvent());
      }
    } else if (event is GenerateWorkoutsEvent) {
      // Generate random workouts
      final random = Random();
      final workoutTypes = ['Yoga', 'Whole Body', 'Stretching', 'Cardio'];
      final workoutCount = random.nextInt(4) + 1;
      final workouts = List<String>.generate(workoutCount,
          (_) => workoutTypes[random.nextInt(workoutTypes.length)]);

      yield WorkoutsGeneratedState(workouts);
    }
  }
}
