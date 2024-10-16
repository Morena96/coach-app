import 'dart:typed_data';

import 'package:coach_app/features/antenna_system/infrastructure/repositories/antenna_command_repository.dart';
import 'package:domain/features/antenna_system/services/serial_port_service.dart';
import 'package:domain/features/logging/repositories/logger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([SerialPortCommandService, LoggerRepository])
import 'antenna_command_repository_test.mocks.dart';

void main() {
  late AntennaCommandRepositoryImpl repository;
  late MockSerialPortCommandService mockSerialPortService;
  late MockLoggerRepository mockLoggerRepository;

  setUp(() {
    mockSerialPortService = MockSerialPortCommandService();
    mockLoggerRepository = MockLoggerRepository();
    repository = AntennaCommandRepositoryImpl(mockSerialPortService, mockLoggerRepository);
  });

  group('AntennaCommandRepositoryImpl', () {
    test('sendCommand calls SerialPortCommandService.sendCommand', () async {
      const portName = 'port1';
      final command = Uint8List.fromList([1, 2, 3, 4]);

      when(mockSerialPortService.sendCommand(portName, command))
          .thenAnswer((_) => Future.value());

      await repository.sendCommand(portName, command);

      verify(mockSerialPortService.sendCommand(portName, command)).called(1);
      verify(mockLoggerRepository.info(any))
          .called(1);
    });

    test('sendCommand throws AntennaCommandExcept ion on error', () async {
      const portName = 'port1';
      final command = Uint8List.fromList([1, 2, 3, 4]);

      when(mockSerialPortService.sendCommand(portName, command))
          .thenThrow(Exception('Test error'));

      expect(
        () => repository.sendCommand(portName, command),
        throwsA(isA<AntennaCommandException>().having(
            (e) => e.toString(),
            'message',
            contains('Failed to send command: Exception: Test error'))),
      );
      expect(
        verify(mockLoggerRepository.error(captureAny)).captured,
        contains('Failed to send command to port1: [1, 2, 3, 4]'),
      );
    });

    test('closePort calls SerialPortCommandService.closePort', () async {
      const portName = 'port1';

      when(mockSerialPortService.closePort(portName))
          .thenAnswer((_) => Future.value());

      await repository.closePort(portName);

      verify(mockSerialPortService.closePort(portName)).called(1);
      verify(mockLoggerRepository.info(any))
          .called(1);
    });

    test('closePort throws AntennaCommandException on error', () async {
      const portName = 'port1';

      when(mockSerialPortService.closePort(portName))
          .thenThrow(Exception('Test error'));

      expect(
        () => repository.closePort(portName),
        throwsA(isA<AntennaCommandException>().having(
            (e) => e.toString(),
            'message',
            contains('Failed to close port port1: Exception: Test error'))),
      );
      expect(
        verify(mockLoggerRepository.error(captureAny)).captured,
        contains('Failed to close port port1: Exception: Test error'),
      );
    });

    test('closeAllPorts calls SerialPortCommandService.closeAll', () async {
      when(mockSerialPortService.closeAll()).thenAnswer((_) => Future.value());

      await repository.closeAllPorts();

      verify(mockSerialPortService.closeAll()).called(1);
      verify(mockLoggerRepository.info(any))
          .called(1);
    });

    test('closeAllPorts throws AntennaCommandException on error', () async {
      when(mockSerialPortService.closeAll()).thenThrow(Exception('Test error'));

      expect(
        () => repository.closeAllPorts(),
        throwsA(isA<AntennaCommandException>().having(
            (e) => e.toString(),
            'message',
            contains('Failed to close all ports: Exception: Test error'))),
      );
      expect(
        verify(mockLoggerRepository.error(captureAny)).captured,
        contains('Failed to close all ports: Exception: Test error'),
      );
    });
  });
}
