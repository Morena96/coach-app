import 'dart:async';

import 'package:domain/features/antenna_system/entities/antenna_state.dart';
import 'package:domain/features/antenna_system/entities/error_state.dart';
import 'package:domain/features/antenna_system/state_machine/antenna_state_machine.dart';
import 'package:meta/meta.dart';

abstract class TimeoutState extends AntennaState {
  final Duration timeout;
  final int maxRetries;
  Timer? _timer;
  int _retryCount = 0;

  TimeoutState(super.context,
      {this.timeout = const Duration(seconds: 5), this.maxRetries = 3});

  void startTimer(AntennaStateMachine stateMachine) {
    _timer = Timer(timeout, () => onTimeout(stateMachine));
  }

  void cancelTimer() {
    _timer?.cancel();
  }

  void onTimeout(AntennaStateMachine stateMachine) {
    if (_retryCount < maxRetries) {
      _retryCount++;
      retry(stateMachine);
    } else {
      stateMachine.setState(ErrorState(context, 'Timeout'));
    }
  }

  void retry(AntennaStateMachine stateMachine) {
    cancelTimer();
    startTimer(stateMachine);
  }

  @override
  void onExit() {
    cancelTimer();
    super.onExit();
  }

  @override
  void onEnter(AntennaStateMachine stateMachine) {
    _retryCount = 0;
    startTimer(stateMachine);
  }

  @visibleForTesting
  bool isTimerActive() {
    return _timer != null && _timer!.isActive;
  }
}
