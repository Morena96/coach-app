import 'dart:typed_data';

/// Abstract class defining the methods to send commands to the antenna system
/// using a serial port
abstract class AntennaCommandRepository {
  /// Sends a command to the antenna system using the specified serial port
  Future<void> sendCommand(String portName, Uint8List command);

  /// Sends a command to all serial ports
  /// This is useful for broadcasting commands to all connected devices
  Future<void> sendCommandToAll(Uint8List command);

  /// Closes the specified serial port
  Future<void> closePort(String portName);

  /// Closes all open serial ports
  Future<void> closeAllPorts();
}
