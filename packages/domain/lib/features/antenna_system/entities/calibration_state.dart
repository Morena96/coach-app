import 'package:binary_data_reader/main.dart';
import 'package:domain/features/antenna_system/calibration/calibration_service.dart';
import 'package:domain/features/antenna_system/entities/antenna_state.dart';
import 'package:domain/features/antenna_system/entities/state_type.dart';
import 'package:domain/features/antenna_system/state_machine/antenna_state_machine.dart';

class CalibrationState extends AntennaState {
  final CalibrationService _calibrationService;

  CalibrationState(super.context, this._calibrationService);

  @override
  get name => 'Calibration State';

  @override
  void onEnter(AntennaStateMachine stateMachine) {
    _calibrationService.startCalibration();
  }

  @override
  void handleCommandReceived(
      Command command, AntennaStateMachine stateMachine) {
    if (command is ScanRfCommand) {
      _calibrationService.handleCalibrationResponse(command);
    }
  }

  @override
  StateType get stateType => StateType.calibration;
}
