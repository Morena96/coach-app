import 'dart:typed_data';

import 'package:application/antenna_system/hex_converter.dart';
import 'package:application/antenna_system/use_cases/send_antenna_command.dart';
import 'package:domain/features/antenna_system/repositories/antenna_command_repository.dart';
import 'package:test/test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([AntennaCommandRepository, HexConverter])
import 'send_antenna_command_use_case_test.mocks.dart';

void main() {
  late SendAntennaCommandUseCase useCase;
  late MockAntennaCommandRepository mockRepository;
  late MockHexConverter mockHexConverter;

  setUp(() {
    mockRepository = MockAntennaCommandRepository();
    mockHexConverter = MockHexConverter();

    useCase = SendAntennaCommandUseCase(mockRepository, mockHexConverter);
  });

  group('SendAntennaCommandUseCase', () {
    test('should send command successfully', () async {
      // Arrange
      const portName = 'TEST_PORT';
      const command = '0102030405';
      when(mockRepository.sendCommand(any, any)).thenAnswer((_) async {});
      when(mockHexConverter.hexToBytes(any)).thenReturn(Uint8List.fromList([1, 2, 3, 4, 5]));

      // Act
      await useCase(portName, command);

      // Assert
      verify(mockRepository.sendCommand(portName, any)).called(1);
    });

    test('should throw exception when repository throws', () async {
      // Arrange
      const portName = 'TEST_PORT';
      const command = '0102030405';
      when(mockRepository.sendCommand(any, any))
          .thenThrow(Exception('Test error'));
      when(mockHexConverter.hexToBytes(any)).thenReturn(Uint8List.fromList([1, 2, 3, 4, 5]));

      // Act & Assert
      expect(() => useCase(portName, command), throwsException);
    });

    test('should handle empty command gracefully', () async {
      // Arrange
      const portName = 'TEST_PORT';
      const command = '';

      when(mockRepository.sendCommand(any, any)).thenAnswer((_) async {});
      when(mockHexConverter.hexToBytes(any)).thenThrow(const FormatException('Invalid hex string'));

      // Act & Assert
      expect(() => useCase(portName, command), throwsA(isA<FormatException>()));
    });

    test('should handle invalid hex string', () async {
      // Arrange
      const portName = 'TEST_PORT';
      const command = 'GGHHIIJJ'; // Invalid hex string

      when(mockRepository.sendCommand(any, any)).thenAnswer((_) async {});
      when(mockHexConverter.hexToBytes(any)).thenThrow(const FormatException('Invalid hex string'));

      // Act & Assert
      expect(() => useCase(portName, command), throwsA(isA<FormatException>()));
    });
  });
}
