import 'dart:math';
import 'dart:typed_data';

import 'package:domain/features/antenna_system/entities/antenna_info.dart';
import 'package:domain/features/antenna_system/services/serial_port_service.dart';

/// Mock implementation of the SerialPortService
/// Provides mock data for testing
/// Does not actually interact with any hardware
/// Simulates a list of available ports and antenna information
/// as well as sending commands and receiving data
/// via a stream
class MockSerialPortImpl
    implements
        SerialPortService,
        SerialPortCommandService,
        SerialPortDataService {
  final Random _random = Random();

  @override
  List<AntennaInfo> getAvailableAntenna() {
    // Simulate a random number of available ports
    final portCount = _random.nextInt(5) + 1; // 1 to 5 ports
    return List.generate(portCount, (index) {
      final portName = 'COM${index + 1}';
      return getAntennaInfo(portName);
    });
  }

  @override
  List<String> getAvailablePorts() {
    // Simulate a random number of available ports
    final portCount = _random.nextInt(5) + 1; // 1 to 5 ports
    return List.generate(portCount, (index) => 'COM${index + 1}');
  }

  @override
  AntennaInfo getAntennaInfo(String portName) {
    // Generate mock antenna info
    return AntennaInfo(
      portName: portName,
      description: 'Mock Antenna $portName',
      serialNumber: 'SN${_random.nextInt(10000)}',
      vendorId: 0x1915,
      // Using the constant from the previous example
      productId: 0x520f, // Using the constant from the previous example
    );
  }

  @override
  Stream<List<AntennaInfo>> getAntennaStream() {
    // Simulate a stream of antenna info
    return Stream.periodic(const Duration(seconds: 1)).map((_) {
      final availablePorts = getAvailablePorts();
      return availablePorts.map((portName) {
        return getAntennaInfo(portName);
      }).toList();
    });
  }

  @override
  Future<void> sendCommand(String portName, Uint8List command) async {
    // Simulate sending a command
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<void> sendCommandToAll(Uint8List command) async {
    // Simulate sending a command to all ports
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<void> closeAll() async {
    // Simulate closing all ports
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<void> closePort(String portName) async {
    // Simulate closing a port
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Stream<Uint8List> getDataStream(String portName) {
    // Simulate a data stream
    return Stream.periodic(
            const Duration(seconds: 1), (index) => Uint8List.fromList([index]))
        .take(3);
  }
}
