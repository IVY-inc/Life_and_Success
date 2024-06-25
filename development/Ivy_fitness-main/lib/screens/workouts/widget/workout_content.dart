import 'package:fitness_flutter/core/const/color_constants.dart';
import 'package:fitness_flutter/core/const/data_constants.dart';
import 'package:fitness_flutter/data/workout_data.dart';
import 'package:fitness_flutter/screens/tab_bar/page/tab_bar_page.dart';
import 'package:fitness_flutter/screens/workouts/widget/workout_card.dart';
import 'package:flutter/material.dart';

class WorkoutContent extends StatelessWidget {
  WorkoutContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => TabBarPage()),
                  (route) => false);
            },
            icon: Icon(Icons.arrow_back)),
        title: Text(
          'Workouts',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Container(
          color: ColorConstants.homeBackgroundColor,
          height: double.infinity,
          width: double.infinity,
          child: _createHomeBody(context),
        ),
      ),
    );
  }

  Widget _createHomeBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView(
              children: DataConstants.workouts
                  .map(
                    (e) => _createWorkoutCard(e),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _createWorkoutCard(WorkoutData workoutData) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: WorkoutCard(workout: workoutData),
    );
  }
}
