import 'dart:typed_data';

import 'package:coach_app/features/antenna_system/infrastructure/datasources/mock_serialport_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MockSerialPortAdapter', () {
    late MockSerialPortImpl mockSerialPortAdapter;

    setUp(() {
      mockSerialPortAdapter = MockSerialPortImpl();
    });

    test('should return a list of available ports', () {
      final ports = mockSerialPortAdapter.getAvailablePorts();
      expect(ports, isNotEmpty);
      expect(ports.length, lessThanOrEqualTo(5));
    });

    test('should return a list of available antennas', () {
      final antennas = mockSerialPortAdapter.getAvailableAntenna();
      expect(antennas, isNotEmpty);
      expect(antennas.length, lessThanOrEqualTo(5));
      for (var antenna in antennas) {
        expect(antenna.portName, startsWith('COM'));
        expect(antenna.serialNumber, startsWith('SN'));
      }
    });

    test('should return antenna info for a specific port', () {
      const portName = 'COM1';
      final antennaInfo = mockSerialPortAdapter.getAntennaInfo(portName);
      expect(antennaInfo.portName, portName);
      expect(antennaInfo.description, 'Mock Antenna $portName');
      expect(antennaInfo.serialNumber, startsWith('SN'));
      expect(antennaInfo.vendorId, 0x1915);
      expect(antennaInfo.productId, 0x520f);
    });

    test('should stream a list of antennas periodically', () async {
      final antennaStream = mockSerialPortAdapter.getAntennaStream();
      final antennaList = await antennaStream.take(3).toList();
      expect(antennaList, hasLength(3));
      for (var antennas in antennaList) {
        expect(antennas, isNotEmpty);
        expect(antennas.length, lessThanOrEqualTo(5));
        for (var antenna in antennas) {
          expect(antenna.portName, startsWith('COM'));
          expect(antenna.serialNumber, startsWith('SN'));
        }
      }
    });

    test('should send a command to a specific port', () async {
      const portName = 'COM1';
      final command = Uint8List.fromList([1, 2, 3, 4]);
      await mockSerialPortAdapter.sendCommand(portName, command);
      // If no exception is thrown, the test passes
    });

    test('should send a command to all ports', () async {
      final command = Uint8List.fromList([1, 2, 3, 4]);
      await mockSerialPortAdapter.sendCommandToAll(command);
      // If no exception is thrown, the test passes
    });

    test('should close all ports', () async {
      await mockSerialPortAdapter.closeAll();
      // If no exception is thrown, the test passes
    });

    test('should close a specific port', () async {
      const portName = 'COM1';
      await mockSerialPortAdapter.closePort(portName);
      // If no exception is thrown, the test passes
    });

    test('should stream data from a specific port', () async {
      const portName = 'COM1';
      final dataStream = mockSerialPortAdapter.getDataStream(portName);
      final dataList = await dataStream.toList();
      expect(dataList, hasLength(3));
      for (var i = 0; i < dataList.length; i++) {
        expect(dataList[i], Uint8List.fromList([i]));
      }
    });
  });
}
