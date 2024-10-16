import 'package:binary_data_reader/main.dart';
import 'package:domain/features/antenna_system/entities/calibration_result.dart';

/// Calibration service abstract class
/// which is used to start calibration process and handle calibration response
abstract class CalibrationService {
  /// Start calibration process
  Future<CalibrationResult?> startCalibration();

  /// Handle calibration response
  void handleCalibrationResponse(ScanRfCommand command);
}
