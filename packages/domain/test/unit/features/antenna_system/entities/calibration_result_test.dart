import 'package:test/test.dart';
import 'package:domain/features/antenna_system/entities/calibration_result.dart';

void main() {
  group('CalibrationResult', () {
    test('should create a CalibrationResult with the given rssiMap', () {
      // Arrange
      final Map<int, List<int>> rssiMap = {
        1: [10, 20, 30],
        2: [15, 25, 35],
        3: [5, 15, 25],
      };

      // Act
      final calibrationResult = CalibrationResult(rssiMap);

      // Assert
      expect(calibrationResult.rssiMap, equals(rssiMap));
    });

    test('should create an empty CalibrationResult', () {
      // Arrange
      final Map<int, List<int>> emptyRssiMap = {};

      // Act
      final calibrationResult = CalibrationResult(emptyRssiMap);

      // Assert
      expect(calibrationResult.rssiMap, isEmpty);
    });

    test('should not modify the original rssiMap', () {
      // Arrange
      final Map<int, List<int>> originalRssiMap = {
        1: [10, 20, 30],
        2: [15, 25, 35],
      };
      final calibrationResult = CalibrationResult(originalRssiMap);

      // Act
      originalRssiMap[1]!.add(40);
      originalRssiMap[3] = [5, 15, 25];

      // Assert
      expect(calibrationResult.rssiMap, equals({
        1: [10, 20, 30],
        2: [15, 25, 35],
      }));
    });
  });
}
