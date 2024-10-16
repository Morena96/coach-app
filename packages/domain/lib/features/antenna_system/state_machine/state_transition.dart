import 'package:domain/features/antenna_system/entities/state_type.dart';

class StateTransition {
  final StateType currentState;
  final StateType nextState;

  const StateTransition(this.currentState, this.nextState);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StateTransition &&
          runtimeType == other.runtimeType &&
          currentState == other.currentState &&
          nextState == other.nextState;

  @override
  int get hashCode => currentState.hashCode ^ nextState.hashCode;
}
