import 'package:binary_data_reader/src/commands/models/command.dart';
import 'package:domain/features/antenna_system/entities/antenna_state.dart';
import 'package:domain/features/antenna_system/entities/state_type.dart';
import 'package:domain/features/antenna_system/state_machine/antenna_state_machine.dart';

class IdleState extends AntennaState {
  IdleState(super.context);

  @override
  get name => 'Idle State';

  @override
  void handleCommandReceived(Command command, AntennaStateMachine stateMachine) {
    // TODO: implement handleCommandReceived
  }

  @override
  StateType get stateType => StateType.idle;
}
