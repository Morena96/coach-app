import 'package:binary_data_reader/main.dart';
import 'package:domain/features/antenna_system/calibration/calibration_manager.dart';
import 'package:domain/features/antenna_system/calibration/calibration_notifier.dart';
import 'package:domain/features/antenna_system/entities/calibration_result.dart';
import 'package:domain/features/antenna_system/repositories/antenna_command_repository.dart';
import 'package:domain/features/antenna_system/repositories/antenna_data_repository.dart';
import 'package:test/test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks(
    [AntennaDataRepository, AntennaCommandRepository, CalibrationNotifier])
import 'calibration_manager_test.mocks.dart';

void main() {
  group('CalibrationManager', () {
    late MockAntennaDataRepository mockDataRepository;
    late MockAntennaCommandRepository mockCommandRepository;
    late MockCalibrationNotifier mockNotifier;
    late CalibrationManager calibrationManager;

    setUp(() {
      mockDataRepository = MockAntennaDataRepository();
      mockCommandRepository = MockAntennaCommandRepository();
      mockNotifier = MockCalibrationNotifier();
      calibrationManager = CalibrationManager(
          dataRepository: mockDataRepository,
          commandRepository: mockCommandRepository,
          notifier: mockNotifier,
          parsingStrategy: GatewayParsingStrategy());
    });

    test('successful calibration process', () async {
      // Arrange
      when(mockCommandRepository.sendCommand(any, any))
          .thenAnswer((_) async => Future.value());

      // Act
      final result = await calibrationManager.startCalibration();

      // Assert
      expect(result, isNotNull);
      expect(result, isA<CalibrationResult>());
      verify(mockNotifier.onComplete()).called(1);
    });

    test('calibration process fails and triggers error', () async {
      // Arrange
      when(mockCommandRepository.sendCommand(any, any))
          .thenAnswer((_) async => Future.value());
      when(mockNotifier.onComplete()).thenThrow(Exception("Error"));

      // Act
      final result = await calibrationManager.startCalibration();

      // Assert
      expect(result, isNull);
      verify(mockNotifier.onError(argThat(contains("Calibration failed")))).called(1);
    });

    test('handleCalibrationResponse processes valid response', () {
      // Arrange
      final command = ScanRfCommand(
          frequency: 10, rssiData: List.generate(200, (index) => index));

      // Act
      calibrationManager.handleCalibrationResponse(command);

      // Assert
      expect(calibrationManager.rssiMap[10], isNotNull);
      expect(calibrationManager.rssiMap[10]?.length, 200);
    });
  });
}
