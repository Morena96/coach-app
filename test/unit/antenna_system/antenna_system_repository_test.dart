import 'dart:async';

import 'package:coach_app/features/antenna_system/infrastructure/repositories/antenna_system_repository_impl.dart';
import 'package:domain/features/antenna_system/entities/antenna_info.dart';
import 'package:domain/features/antenna_system/repositories/antenna_system_repository.dart';
import 'package:domain/features/antenna_system/services/serial_port_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([SerialPortService])
import 'antenna_system_repository_test.mocks.dart';

void main() {
  late AntennaSystemRepositoryImpl repository;
  late MockSerialPortService mockService;
  late List<AntennaInfo> mockAntennas;

  setUp(() {
    mockService = MockSerialPortService();
    repository = AntennaSystemRepositoryImpl(mockService);
    mockAntennas = [
      AntennaInfo(
        portName: 'COM1',
        description: 'Antenna 1',
        serialNumber: '123456',
        vendorId: 1001,
        productId: 2001,
      ),
      AntennaInfo(
        portName: 'COM2',
        description: 'Antenna 2',
        serialNumber: '789012',
        vendorId: 1002,
        productId: 2002,
      ),
    ];
  });

  tearDown(() {
    repository.dispose();
  });

  group('AntennaSystemRepositoryImpl', () {
    test(
        'getAntennaSystemStream emits connected state when antennas are available',
        () async {
      final antennas = [
        AntennaInfo(
            portName: 'port1',
            description: 'Antenna 1',
            serialNumber: '123',
            vendorId: 0x1915,
            productId: 0x520f)
      ];

      when(mockService.getAntennaStream())
          .thenAnswer((_) => Stream.value(antennas));

      final stream = repository.getAntennaSystemStream();

      await expectLater(stream, emitsThrough(
          predicate<(AntennaSystemState, List<AntennaInfo>)>((tuple) {
        final (state, emittedAntennas) = tuple;
        return state == AntennaSystemState.connected &&
            emittedAntennas.length == 1 &&
            emittedAntennas[0].portName == 'port1' &&
            emittedAntennas[0].description == 'Antenna 1' &&
            emittedAntennas[0].serialNumber == '123' &&
            emittedAntennas[0].vendorId == 0x1915 &&
            emittedAntennas[0].productId == 0x520f;
      })));
    });

    test(
        'getAntennaSystemStream can properly handle an error on the getAntennaStream() stream',
        () {
      when(mockService.getAntennaStream())
          .thenAnswer((_) => Stream.error(Exception('Error')));

      final stream = repository.getAntennaSystemStream();

      expectLater(stream, emitsThrough(
        predicate<(AntennaSystemState, List<AntennaInfo>)>((tuple) {
          final (state, antennas) = tuple;
          return state == AntennaSystemState.error && antennas.isEmpty;
        }),
      ));
    });

    test('should emit connected state when antennas are present', () async {
      when(mockService.getAntennaStream())
          .thenAnswer((_) => Stream.value(mockAntennas));

      final result = repository.getAntennaSystemStream();

      expectLater(
        result,
        emitsInOrder([
          (AntennaSystemState.connected, mockAntennas),
        ]),
      );
    });
  });
}
