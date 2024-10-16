import 'package:binary_data_reader/main.dart';
import 'package:domain/features/antenna_system/entities/antenna_state.dart';
import 'package:domain/features/antenna_system/entities/state_type.dart';
import 'package:domain/features/antenna_system/state_machine/antenna_state_machine.dart';

class PendingLiveModeState extends AntennaState {
  PendingLiveModeState(super.context);

  @override
  void onEnter(AntennaStateMachine stateMachine) {
    context.logger.info('Entering PendingLiveModeState');
  }

  @override
  String get name => 'PendingLiveModeState';

  @override
  void handleCommandReceived(
      Command command, AntennaStateMachine stateMachine) {}

  @override
  StateType get stateType => StateType.pendingLiveMode;
}
