import 'dart:typed_data';

/// DataSource
///
/// This class represents the initial source of data within the system. It is responsible for
/// providing a stream of raw data, typically in the form of `Uint8List`. DataSource could be
/// implemented to fetch data from various sources such as network streams, files, or other
/// I/O devices.
///
/// Responsibilities:
/// - Providing a continuous stream of raw binary data.
/// - Handling initialization and teardown of any necessary resources for data acquisition.
abstract class DataSource {
  Stream<Uint8List> get dataStream;
  Future<void> initialize();
  Future<void> dispose();
}
