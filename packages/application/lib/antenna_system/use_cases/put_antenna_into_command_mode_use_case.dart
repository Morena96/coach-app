import 'package:domain/features/antenna_system/state_machine/antenna_state_machine.dart';

class PutAntennaIntoCommandModeUseCase {
  final AntennaStateMachine stateMachine;

  PutAntennaIntoCommandModeUseCase(this.stateMachine);

  Future<bool> execute() async {
    return await stateMachine.transitionToCommandMode();
  }
}
