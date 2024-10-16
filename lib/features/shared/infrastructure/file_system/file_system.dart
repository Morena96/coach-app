import 'dart:typed_data';

/// Abstract class defining the contract for file system operations.
abstract class FileSystemService {
  /// Saves the data to the specified path.
  /// Returns the path where the data was saved.
  Future<String> write(String path, Uint8List data);

  /// Checks if a file exists at the given path.
  Future<bool> exists(String path);

  /// Reads the contents of a file as bytes.
  Future<Uint8List> read(String path);

  /// Deletes the file at the given path.
  Future<void> delete(String path);
}