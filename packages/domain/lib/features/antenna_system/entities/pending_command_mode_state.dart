import 'package:binary_data_reader/main.dart';
import 'package:domain/features/antenna_system/entities/antenna_state.dart';
import 'package:domain/features/antenna_system/entities/state_type.dart';
import 'package:domain/features/antenna_system/state_machine/antenna_state_machine.dart';

class PendingCommandModeState extends AntennaState {
  PendingCommandModeState(super.context);

  @override
  void onEnter(AntennaStateMachine stateMachine) {
    context.logger.info('Entering PendingCommandModeState');
  }

  @override
  String get name => 'PendingCommandModeState';

  @override
  void handleCommandReceived(Command command, AntennaStateMachine stateMachine) {
    context.logger.info('Received Command while in PendingCommandModeState: $command');
  }

  @override
  StateType get stateType => StateType.pendingCommandMode;
}
