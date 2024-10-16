import 'dart:typed_data';

import 'package:domain/features/antenna_system/entities/antenna_info.dart';

///
/// Interface for the SerialPortService
/// Provides methods to get available ports and antenna information
///
abstract class SerialPortService {
  /// Get a list of all available antenna
  List<AntennaInfo> getAvailableAntenna();

  /// Get a list of available serial ports
  List<String> getAvailablePorts();

  /// Get information about an antenna connected to a serial port
  AntennaInfo getAntennaInfo(String portName);

  /// Get a stream of antenna information
  Stream<List<AntennaInfo>> getAntennaStream();
}

/// Interface for the SerialPortCommandService
abstract class SerialPortCommandService {
  /// Send a command to a serial port
  Future<void> sendCommand(String portName, Uint8List command);

  /// Send a command to all serial ports
  /// This method is useful for broadcasting commands to multiple ports
  Future<void> sendCommandToAll(Uint8List command);

  /// Close all serial ports
  Future<void> closeAll();

  /// Close a specific serial port
  Future<void> closePort(String portName);
}

/// Interface for the SerialPortDataService
abstract class SerialPortDataService {
  /// Get a stream of data from a serial port
  Stream<Uint8List> getDataStream(String portName);

  /// Close all data streams
  Future<void> closeAll();

  /// Close a specific data stream
  Future<void> closePort(String portName);
}
