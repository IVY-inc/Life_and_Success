part of 'workouts_bloc.dart';

@immutable
abstract class WorkoutsEvent {}
abstract class UserEvent {
  String? get userId => null;
}
class GenerateWorkoutsEvent extends WorkoutsEvent {}
class CheckIfNewUserEvent extends WorkoutsEvent {
  final String uid;

 CheckIfNewUserEvent( {required this.uid});

  
}

class CardTappedEvent extends WorkoutsEvent {
  final WorkoutData workout;

  CardTappedEvent({required this.workout});
}
