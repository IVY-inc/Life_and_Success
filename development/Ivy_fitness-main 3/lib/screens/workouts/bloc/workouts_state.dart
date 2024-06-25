part of 'workouts_bloc.dart';

@immutable
abstract class WorkoutsState {}
abstract class UserState {}

class UserInitial extends UserState {}
class UserNew extends UserState {}
class UserExisting extends UserState {}
class UserError extends UserState {
  final String message;

  UserError(this.message);
}

class WorkoutsInitial extends WorkoutsState {}
class NewUserState extends WorkoutsState {}

class WorkoutsGeneratedState extends WorkoutsState {
  final List<String> workouts;

  WorkoutsGeneratedState(this.workouts);
}

class CardTappedState extends WorkoutsState {
  final WorkoutData workout;

  CardTappedState({required this.workout});
}
