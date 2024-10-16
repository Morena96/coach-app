import 'package:binary_data_reader/main.dart';
import 'package:domain/features/antenna_system/entities/antenna_state.dart';
import 'package:domain/features/antenna_system/entities/state_type.dart';
import 'package:domain/features/antenna_system/state_machine/antenna_state_machine.dart';

class LiveModeState extends AntennaState {
  LiveModeState(super.context);

  @override
  get name => 'Live Mode';


  @override
  void handleCommandReceived(Command command, AntennaStateMachine stateMachine) {
    
  }

  @override
  StateType get stateType => StateType.liveMode;
}
