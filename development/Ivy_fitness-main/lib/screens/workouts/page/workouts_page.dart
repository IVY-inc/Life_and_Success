// ignore: unused_import
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_flutter/screens/health_data_input.dart';
import 'package:fitness_flutter/screens/workout_details_screen/page/workout_details_page.dart';
import 'package:fitness_flutter/screens/workouts/bloc/workouts_bloc.dart';
import 'package:fitness_flutter/screens/workouts/widget/workout_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WorkoutsPage extends StatelessWidget {
  const WorkoutsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildContext(context));
  }

  BlocProvider<WorkoutsBloc> _buildContext(BuildContext context) {
    final String userUid = 'userID'; // Replace with actual user UID

    return BlocProvider<WorkoutsBloc>(
      create: (context) =>
          WorkoutsBloc()..add(CheckIfNewUserEvent(uid: userUid)),
      child: BlocConsumer<WorkoutsBloc, WorkoutsState>(
        buildWhen: (_, currState) =>
            currState is WorkoutsInitial ||
            currState is WorkoutsGeneratedState ||
            currState is NewUserState,
        builder: (context, state) {
          if (state is WorkoutsGeneratedState) {
            return _buildInitialScreen(context, state.workouts);
          } else if (state is NewUserState) {
            return _buildNewUserScreen(context);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
        listenWhen: (_, currState) => currState is CardTappedState,
        listener: (context, state) {
          if (state is CardTappedState) {
            Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(
                builder: (_) => WorkoutDetailsPage(workout: state.workout),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildInitialScreen(BuildContext context, List<String> workouts) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              'Это ваши тренировки на сегодня....',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(height: 16),
          ...workouts
              .map((workout) => Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(workout, style: TextStyle(fontSize: 16)),
                  ))
              .toList(),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) =>
                      WorkoutContent(), // This should navigate to your actual workout page
                ),
              );
            },
            child: Text('Continue'),
          ),
        ],
      ),
    );
  }

  Widget _buildNewUserScreen(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'We need to analyze your data first. Please input your health data in the next screen.',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => HealthDataInputPage(),
                ),
              );
            },
            child: Text('Continue'),
          ),
        ],
      ),
    );
  }
}
