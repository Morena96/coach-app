import 'package:binary_data_reader/main.dart';
import 'package:domain/features/antenna_system/calibration/calibration_service.dart';
import 'package:domain/features/antenna_system/entities/calibration_state.dart';
import 'package:domain/features/antenna_system/entities/state_type.dart';
import 'package:domain/features/antenna_system/repositories/antenna_command_repository.dart';
import 'package:domain/features/antenna_system/state_machine/antenna_context.dart';
import 'package:domain/features/antenna_system/state_machine/antenna_state_machine.dart';
import 'package:domain/features/logging/repositories/logger.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

@GenerateMocks([
  AntennaStateMachine,
  CalibrationService,
  AntennaCommandRepository,
  ScanRfCommand,
  Command,
  LoggerRepository
])
import 'calibration_state_test.mocks.dart';

void main() {
  late CalibrationState calibrationState;
  late MockAntennaStateMachine mockStateMachine;
  late MockCalibrationService mockCalibrationService;
  late MockAntennaCommandRepository mockRepository;
  late AntennaContext context;

  setUp(() {
    mockStateMachine = MockAntennaStateMachine();
    mockCalibrationService = MockCalibrationService();
    mockRepository = MockAntennaCommandRepository();
    context = AntennaContext(
        repository: mockRepository,
        parsingStrategy: GatewayParsingStrategy(),
        logger: MockLoggerRepository());
    calibrationState = CalibrationState(context, mockCalibrationService);
  });

  test('onEnter calls startCalibration on CalibrationService', () {
    // stubbing the startCalibration method
    when(mockCalibrationService.startCalibration())
        .thenAnswer((_) async => null);

    calibrationState.onEnter(mockStateMachine);
    verify(mockCalibrationService.startCalibration()).called(1);
  });

  test('name is Calibration State', () {
    expect(calibrationState.name, equals('Calibration State'));
  });

  group('handleCommandReceived', () {
    test('calls handleCalibrationResponse for ScanRfCommand', () {
      final scanRfCommand = MockScanRfCommand();
      calibrationState.handleCommandReceived(scanRfCommand, mockStateMachine);
      verify(mockCalibrationService.handleCalibrationResponse(scanRfCommand))
          .called(1);
    });

    test('does not call handleCalibrationResponse for other command types', () {
      final otherCommand = MockCommand();
      calibrationState.handleCommandReceived(otherCommand, mockStateMachine);
      verifyNever(mockCalibrationService.handleCalibrationResponse(any));
    });

    test('stateType getter returns StateType.calibration', () {
      expect(calibrationState.stateType, equals(StateType.calibration));
    });
  });
}
