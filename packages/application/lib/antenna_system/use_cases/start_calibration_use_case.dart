import 'package:domain/features/antenna_system/state_machine/antenna_state_machine.dart';

class StartCalibrationUseCase {
  final AntennaStateMachine _antennaStateMachine;

  StartCalibrationUseCase(this._antennaStateMachine);

  void execute() {
    _antennaStateMachine.startCalibration();
  }
}
