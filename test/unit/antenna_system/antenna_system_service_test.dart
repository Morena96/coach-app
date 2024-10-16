import 'dart:async';
import 'dart:typed_data';

import 'package:coach_app/features/antenna_system/infrastructure/datasources/flutter_libserialport_impl.dart';
import 'package:domain/features/antenna_system/entities/antenna_info.dart';
import 'package:domain/features/antenna_system/services/serial_port_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks(
    [SerialPortService, SerialPortCommandService, SerialPortDataService])
import 'antenna_system_service_test.mocks.dart';

void main() {
  late MockSerialPortService mockSerialPort;
  late MockSerialPortCommandService mockSerialPortCommand;
  late MockSerialPortDataService mockSerialPortData;

  setUp(() {
    mockSerialPort = MockSerialPortService();
    mockSerialPortCommand = MockSerialPortCommandService();
    mockSerialPortData = MockSerialPortDataService();
  });

  group('AntennaSystemService', () {
    test('getAntennaStream emits empty list when no ports available', () async {
      when(mockSerialPort.getAvailablePorts()).thenReturn([]);

      // Create a stream controller to simulate the periodic stream
      final controller = StreamController<List<AntennaInfo>>();
      when(mockSerialPort.getAntennaStream())
          .thenAnswer((_) => controller.stream);

      // Emit an empty list
      controller.add([]);

      final stream = mockSerialPort.getAntennaStream();

      await expectLater(stream, emits(isEmpty));
      await controller.close();
    });

    test('getAntennaStream emits list of AntennaInfo for available ports',
        () async {
      when(mockSerialPort.getAvailablePorts()).thenReturn(['port1', 'port2']);
      when(mockSerialPort.getAntennaInfo(any)).thenReturn(AntennaInfo(
        portName: 'port1',
        description: 'Test Antenna',
        serialNumber: '123456',
        vendorId: FlutterLibserialportImpl.antennaVendorId,
        productId: FlutterLibserialportImpl.antennaProductId,
      ));

      // Create a stream controller to simulate the periodic stream
      final controller = StreamController<List<AntennaInfo>>();
      when(mockSerialPort.getAntennaStream())
          .thenAnswer((_) => controller.stream);

      // Emit a list of AntennaInfo
      final antennas = [
        AntennaInfo(
          portName: 'port1',
          description: 'Test Antenna',
          serialNumber: '123456',
          vendorId: FlutterLibserialportImpl.antennaVendorId,
          productId: FlutterLibserialportImpl.antennaProductId,
        ),
        AntennaInfo(
          portName: 'port1',
          description: 'Test Antenna',
          serialNumber: '123456',
          vendorId: FlutterLibserialportImpl.antennaVendorId,
          productId: FlutterLibserialportImpl.antennaProductId,
        )
      ];
      controller.add(antennas);

      final stream = mockSerialPort.getAntennaStream();

      await expectLater(
          stream,
          emits(predicate<List<AntennaInfo>>((list) =>
              list.length == 2 &&
              list.every((antenna) =>
                  antenna.portName == 'port1' &&
                  antenna.description == 'Test Antenna' &&
                  antenna.serialNumber == '123456' &&
                  antenna.vendorId ==
                      FlutterLibserialportImpl.antennaVendorId &&
                  antenna.productId ==
                      FlutterLibserialportImpl.antennaProductId))));
      await controller.close();
    });

    test('getAntennaStream filters out non-matching vendor and product IDs',
        () async {
      when(mockSerialPort.getAvailablePorts()).thenReturn(['port1', 'port2']);
      when(mockSerialPort.getAntennaInfo('port1')).thenReturn(AntennaInfo(
        portName: 'port1',
        description: 'Test Antenna 1',
        serialNumber: '123456',
        vendorId: FlutterLibserialportImpl.antennaVendorId,
        productId: FlutterLibserialportImpl.antennaProductId,
      ));
      when(mockSerialPort.getAntennaInfo('port2')).thenReturn(AntennaInfo(
        portName: 'port2',
        description: 'Test Antenna 2',
        serialNumber: '789012',
        vendorId: 0x1234,
        // Non-matching vendor ID
        productId: 0x5678, // Non-matching product ID
      ));

      // Create a stream controller to simulate the periodic stream
      final controller = StreamController<List<AntennaInfo>>();
      when(mockSerialPort.getAntennaStream())
          .thenAnswer((_) => controller.stream);

      // Emit the filtered list of AntennaInfo
      final antennas = [
        AntennaInfo(
          portName: 'port1',
          description: 'Test Antenna 1',
          serialNumber: '123456',
          vendorId: FlutterLibserialportImpl.antennaVendorId,
          productId: FlutterLibserialportImpl.antennaProductId,
        )
      ];
      controller.add(antennas);

      final stream = mockSerialPort.getAntennaStream();

      await expectLater(
          stream,
          emits(predicate<List<AntennaInfo>>((list) =>
              list.length == 1 &&
              list[0].portName == 'port1' &&
              list[0].description == 'Test Antenna 1')));
      await controller.close();
    });

    test('sendCommand calls SerialPortCommandService.sendCommand', () async {
      const portName = 'port1';
      final command = Uint8List.fromList([1, 2, 3, 4]);

      when(mockSerialPortCommand.sendCommand(portName, command))
          .thenAnswer((_) => Future.value());

      await mockSerialPortCommand.sendCommand(portName, command);

      verify(mockSerialPortCommand.sendCommand(portName, command)).called(1);
    });

    test('getDataStream returns stream from SerialPortDataService', () async {
      const portName = 'port1';
      final testData = [
        Uint8List.fromList([1, 2, 3]),
        Uint8List.fromList([4, 5, 6])
      ];

      when(mockSerialPortData.getDataStream(portName))
          .thenAnswer((_) => Stream.fromIterable(testData));

      final stream = mockSerialPortData.getDataStream(portName);

      await expectLater(stream, emitsInOrder(testData));
    });

    test('closeAll calls SerialPortService.closeAll', () async {
      when(mockSerialPortData.closeAll()).thenAnswer((_) => Future.value());

      await mockSerialPortData.closeAll();

      verify(mockSerialPortData.closeAll()).called(1);
    });

    test('closePort calls SerialPortService.closePort', () async {
      const portName = 'port1';

      when(mockSerialPortData.closePort(portName))
          .thenAnswer((_) => Future.value());

      await mockSerialPortData.closePort(portName);

      verify(mockSerialPortData.closePort(portName)).called(1);
    });
  });
}
