import 'package:binary_data_reader/main.dart';
import 'package:domain/features/antenna_system/entities/antenna_state.dart';
import 'package:domain/features/antenna_system/entities/state_type.dart';
import 'package:domain/features/antenna_system/state_machine/antenna_state_machine.dart';

class ErrorState extends AntennaState {
  final String errorMessage;

  ErrorState(
      super.context, this.errorMessage);

  @override
  void onEnter(AntennaStateMachine stateMachine) {
    context.logger.error(errorMessage);
  }

  @override
  void handleCommandReceived(
      Command command, AntennaStateMachine stateMachine) {
    // Implement error recovery logic if needed
  }

  @override
  String get name => 'ErrorState';

  @override
  StateType get stateType => StateType.error;
}
