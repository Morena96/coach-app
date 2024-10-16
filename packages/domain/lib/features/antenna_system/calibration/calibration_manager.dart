import 'package:binary_data_reader/main.dart';
import 'package:domain/features/antenna_system/calibration/calibration_notifier.dart';
import 'package:domain/features/antenna_system/calibration/calibration_service.dart';
import 'package:domain/features/antenna_system/entities/calibration_result.dart';
import 'package:domain/features/antenna_system/repositories/antenna_command_repository.dart';
import 'package:domain/features/antenna_system/repositories/antenna_data_repository.dart';

/// Calibration manager class
/// which is used to manage the calibration process
/// and handle calibration response
class CalibrationManager extends CalibrationService {
  /// The data repository for antenna system.
  final AntennaDataRepository dataRepository;

  /// The command repository for antenna system.
  final AntennaCommandRepository commandRepository;

  /// The calibration notifier used to notify changes in calibration process.
  final CalibrationNotifier notifier;

  final FrameParsingStrategy parsingStrategy;

  /// The current step of the calibration process.
  int currentStep = 0;

  /// The total number of steps in the calibration process.
  final int _totalSteps = 35 * 81;

  /// The map of RF frequencies to RSSI data.
  final Map<int, List<int>> _rssiMap = {};

  get rssiMap => _rssiMap;

  CalibrationManager({
    required this.dataRepository,
    required this.commandRepository,
    required this.notifier,
    required this.parsingStrategy,
  });

  @override
  Future<CalibrationResult?> startCalibration() async {
    String portName = 'TEST';
    try {
      _calibrate(portName);
      notifier.onComplete();
      return CalibrationResult(_rssiMap);
    } catch (e) {
      notifier.onError("Calibration failed: ${e.toString()}");
      return null;
    }
  }

  Future<void> _calibrate(String portName) async {
    /// The calibration process is a nested loop that sends calibration commands for each RF frequency.
    for (int rf = 0; rf < 81; rf++) {
      /// The inner loop sends calibration commands for each RF frequency 35 times.
      for (int k = 0; k < 35; k++) {
        await _sendCalibrationCommand(portName, rf);
        _updateProgress();
      }
    }
  }

  Future<void> _sendCalibrationCommand(String portName, int rf) async {
    final command = ScanRfCommand(frequency: rf, rssiData: []);
    await commandRepository.sendCommand(portName,
        Frame.fromCommand(command, parsingStrategy).toBinary(parsingStrategy));
  }

  @override
  void handleCalibrationResponse(ScanRfCommand command) {
    if (_isValidResponse(command)) {
      _processReceivedData(command.frequency, command.rssiData);
    }
  }

  bool _isValidResponse(ScanRfCommand command) {
    // Implement validation logic
    return true; // Placeholder
  }

  /// Process received RSSI data
  /// by adding it to the RSSI map
  /// which we will use to calculate the calibration result
  void _processReceivedData(int rf, List<int> rssiData) {
    _rssiMap[rf] = (_rssiMap[rf] ?? []) + rssiData;
  }

  void _updateProgress() {
    currentStep++;
    final progress = (currentStep / _totalSteps) * 100.0;
    notifier.onProgress(progress);
  }
}
