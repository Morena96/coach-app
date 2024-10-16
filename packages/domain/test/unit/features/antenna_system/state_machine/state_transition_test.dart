import 'package:domain/features/antenna_system/entities/state_type.dart';
import 'package:domain/features/antenna_system/state_machine/state_transition.dart';
import 'package:test/test.dart';

void main() {
  group('StateTransition', () {
    test('should create a StateTransition instance', () {
      const transition = StateTransition(StateType.idle, StateType.commandMode);
      expect(transition.currentState, equals(StateType.idle));
      expect(transition.nextState, equals(StateType.commandMode));
    });

    test('should be equal when current and next states are the same', () {
      const transition1 = StateTransition(StateType.idle, StateType.commandMode);
      const transition2 = StateTransition(StateType.idle, StateType.commandMode);
      expect(transition1, equals(transition2));
    });

    test('should not be equal when current states are different', () {
      const transition1 = StateTransition(StateType.idle, StateType.commandMode);
      const transition2 = StateTransition(StateType.liveMode, StateType.commandMode);
      expect(transition1, isNot(equals(transition2)));
    });

    test('should not be equal when next states are different', () {
      const transition1 = StateTransition(StateType.idle, StateType.commandMode);
      const transition2 = StateTransition(StateType.idle, StateType.liveMode);
      expect(transition1, isNot(equals(transition2)));
    });

    test('should have the same hash code for equal transitions', () {
      const transition1 = StateTransition(StateType.idle, StateType.commandMode);
      const transition2 = StateTransition(StateType.idle, StateType.commandMode);
      expect(transition1.hashCode, equals(transition2.hashCode));
    });

    test('should have different hash codes for different transitions', () {
      const transition1 = StateTransition(StateType.idle, StateType.commandMode);
      const transition2 = StateTransition(StateType.liveMode, StateType.idle);
      expect(transition1.hashCode, isNot(equals(transition2.hashCode)));
    });
  });
}
