import 'package:custom_timer/custom_timer.dart';
import 'package:fitness_flutter/core/service/date_service.dart';
import 'package:flutter/material.dart';

class StartWorkoutTimer extends StatefulWidget {
  final int time;
  final bool isPaused;

  StartWorkoutTimer({
    required this.time,
    required this.isPaused,
  });

  @override
  _StartWorkoutTimerState createState() => _StartWorkoutTimerState();
}

class _StartWorkoutTimerState extends State<StartWorkoutTimer>
    with SingleTickerProviderStateMixin {
  late CustomTimerController _timerController;

  @override
  void initState() {
    super.initState();
    _timerController = CustomTimerController(
        vsync: this,
        begin: Duration(hours: 24),
        end: Duration(),
        initialState: CustomTimerState.reset,
        interval: CustomTimerInterval.milliseconds);
  }

  @override
  Widget build(BuildContext context) {
    return widget.isPaused ? _createPauseText() : _createCountdownTimer();
  }

  Widget _createCountdownTimer() {
    return CustomTimer(
        controller: _timerController,
        builder: (state, time) {
          // Build the widget you want!🎉
          return Text(
              "${time.hours}:${time.minutes}:${time.seconds}.${time.milliseconds}",
              style: TextStyle(fontSize: 24.0));
        });
    // return CustomTimer(
    //   from: Duration(seconds: widget.time),
    //   to: Duration(seconds: 0),
    //   onBuildAction: CustomTimerAction.auto_start,
    //   builder: (CustomTimerRemainingTime remaining) {
    //     return Text(
    //       "${remaining.minutes}:${remaining.seconds}",
    //       style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
    //     );
    //   },
    // );
  }

  Widget _createPauseText() {
    final minutesSeconds = DateService.convertIntoSeconds(widget.time);
    return Text(
      "${minutesSeconds.minutes.toString().padLeft(2, '0')}:${minutesSeconds.seconds.toString().padLeft(2, '0')}",
      style: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
