import 'dart:async';
import 'package:flutter/material.dart';

/// State for CustomTimer.
enum CustomTimerState { reset, paused, counting, finished }

class CustomTimerController extends ChangeNotifier {
  /// Controller for CustomTimer.
  CustomTimerController({
    required Duration begin,
    required Duration end,
    this.initialState = CustomTimerState.reset,
  }) {
    _duration = getDuration(begin, end);
    _begin = begin;
    _end = end;
  }

  Timer? countdownTimer;
  late Duration _duration;

  /// Defines the initial state of the timer. By default it is `CustomTimerState.reset`
  final CustomTimerState initialState;

  /// The start of the timer.
  late Duration _begin;

  /// The end of the timer.
  late Duration _end;

  late CustomTimerState _state = initialState;

  /// Current state of the timer.
  CustomTimerState get state => _state;

  /// Current duration of the timer.
  Duration get duration => _duration;

  /// Set duration of the timer.
  set duration(Duration value) {
    _duration = value;
    notifyListeners();
  }

  Duration getDuration(Duration begin, Duration end) {
    if (begin > end) {
      return begin - end;
    } else {
      return end - begin;
    }
  }

  /// Timer related methods ///
  void start() {
    countdownTimer =
        Timer.periodic(Duration(seconds: 1), (_) => setCountDown());
    _state = CustomTimerState.counting;
    notifyListeners();
  }

  void pause() {
    countdownTimer!.cancel();
    _state = CustomTimerState.paused;
    notifyListeners();
  }

  /// Reset the timer to the initial state or to a new duration
  void reset({Duration? duration}) {
    if (countdownTimer != null) pause();
    _duration = duration ?? getDuration(_begin, _end);
    _state = CustomTimerState.reset;
    notifyListeners();
  }

  void finish() {
    _state = CustomTimerState.finished;
    notifyListeners();
  }

  void setCountDown() {
    final reduceSecondsBy = 1;

    final seconds = _duration.inSeconds - reduceSecondsBy;
    if (seconds < 0) {
      countdownTimer!.cancel();
      _state = CustomTimerState.finished;
    } else {
      _duration = Duration(seconds: seconds);
    }
    notifyListeners();
  }
}
