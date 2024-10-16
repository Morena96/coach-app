import 'dart:typed_data';

/// Abstract class defining the methods to send commands to the antenna system
/// using a serial port
abstract class AntennaDataRepository {
  /// Gets a stream of data from the specified serial port
  Stream<Uint8List> getDataStream(String portName);

  /// Get all data streams
  Stream<(String, Uint8List)> getAllDataStreams();
}
