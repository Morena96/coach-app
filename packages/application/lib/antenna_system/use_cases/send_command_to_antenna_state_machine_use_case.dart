import 'package:binary_data_reader/main.dart';
import 'package:domain/features/antenna_system/state_machine/antenna_state_machine.dart';

class SendCommandToAntennaStateMachineUseCase {
  AntennaStateMachine stateMachine;

  SendCommandToAntennaStateMachineUseCase(this.stateMachine);

  void execute(Command command) {
    stateMachine.sendCommand(command);
  }
}
