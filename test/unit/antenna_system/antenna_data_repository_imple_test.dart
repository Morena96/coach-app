import 'dart:async';
import 'dart:typed_data';

import 'package:domain/features/antenna_system/entities/antenna_info.dart';
import 'package:domain/features/antenna_system/services/serial_port_service.dart';
import 'package:coach_app/features/antenna_system/infrastructure/repositories/antenna_data_repository_impl.dart';
import 'package:coach_app/shared/services/logging/mock_logger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([SerialPortDataService, SerialPortService])
import 'antenna_data_repository_imple_test.mocks.dart';

void main() {
  late AntennaDataRepositoryImpl repository;
  late MockSerialPortDataService mockSerialPortDataService;
  late MockSerialPortService mockSerialPortService;
  late MockLogger mockLogger;
  late StreamController<List<AntennaInfo>> antennaStreamController;

  setUp(() {
    mockSerialPortDataService = MockSerialPortDataService();
    mockSerialPortService = MockSerialPortService();
    antennaStreamController = StreamController<List<AntennaInfo>>.broadcast();
    mockLogger = MockLogger();

    when(mockSerialPortService.getAntennaStream())
        .thenAnswer((_) => antennaStreamController.stream);

    repository = AntennaDataRepositoryImpl(
        mockSerialPortDataService, mockSerialPortService, mockLogger);
  });

  tearDown(() async {
    await antennaStreamController.close();
    await repository.dispose();
  });

  group('AntennaDataRepositoryImpl', () {
    test('initializes and starts antenna monitoring', () {
      verify(mockSerialPortService.getAntennaStream()).called(1);
    });

    test('handles antenna connections', () async {
      const portName = 'COM1';
      final antenna = AntennaInfo(
          portName: portName,
          description: 'Test Antenna',
          serialNumber: '123',
          vendorId: 0,
          productId: 0);

      when(mockSerialPortDataService.getDataStream(portName))
          .thenAnswer((_) => const Stream<Uint8List>.empty());

      antennaStreamController.add([antenna]);

      // Allow time for the repository to process the update
      await Future.delayed(const Duration(milliseconds: 100));

      expect(() => repository.getDataStream(portName), returnsNormally);
    });

    test('handles antenna disconnections', () async {
      const portName = 'COM1';
      final antenna = AntennaInfo(
          portName: portName,
          description: 'Test Antenna',
          serialNumber: '123',
          vendorId: 0,
          productId: 0);

      when(mockSerialPortDataService.getDataStream(portName))
          .thenAnswer((_) => const Stream<Uint8List>.empty());

      // Connect antenna
      antennaStreamController.add([antenna]);
      await Future.delayed(const Duration(milliseconds: 100));

      // Disconnect antenna
      antennaStreamController.add([]);
      await Future.delayed(const Duration(milliseconds: 100));

      // The stream should still exist, but no new data should be coming in
      expect(() => repository.getDataStream(portName), returnsNormally);
    });

    test('forwards data from SerialPortDataService', () async {
      const portName = 'COM1';
      final antenna = AntennaInfo(
          portName: portName,
          description: 'Test Antenna',
          serialNumber: '123',
          vendorId: 0,
          productId: 0);

      final testData = [
        Uint8List.fromList([1, 2, 3]),
        Uint8List.fromList([4, 5, 6]),
      ];

      final dataStreamController = StreamController<Uint8List>();
      when(mockSerialPortDataService.getDataStream(portName))
          .thenAnswer((_) => dataStreamController.stream);

      antennaStreamController.add([antenna]);
      await Future.delayed(const Duration(milliseconds: 100));

      final stream = repository.getDataStream(portName);
      final streamFuture = stream.take(2).toList();

      for (var data in testData) {
        dataStreamController.add(data);
      }

      final result = await streamFuture;
      expect(result, equals(testData));

      await dataStreamController.close();
    });

    test('handles multiple antennas', () async {
      final portNames = ['COM1', 'COM2'];
      final antennas = portNames
          .map((port) => AntennaInfo(
              portName: port,
              description: 'Test Antenna',
              serialNumber: port,
              vendorId: 0,
              productId: 0))
          .toList();

      for (var port in portNames) {
        when(mockSerialPortDataService.getDataStream(port))
            .thenAnswer((_) => const Stream<Uint8List>.empty());
      }

      antennaStreamController.add(antennas);
      await Future.delayed(const Duration(milliseconds: 100));

      for (var port in portNames) {
        expect(() => repository.getDataStream(port), returnsNormally);
      }
    });
  });
}
