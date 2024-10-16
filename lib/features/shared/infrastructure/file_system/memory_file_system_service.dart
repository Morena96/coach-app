import 'dart:typed_data';

import 'package:coach_app/features/shared/infrastructure/file_system/file_system.dart';

/// Implements [FileSystemService] using in-memory storage for testing purposes.
class MemoryFileSystemService implements FileSystemService {
  final Map<String, Uint8List> _files = {};

  @override
  Future<String> write(String path, Uint8List data) async {
    _files[path] = data;
    return path;
  }

  @override
  Future<bool> exists(String path) async {
    return _files.containsKey(path);
  }

  @override
  Future<Uint8List> read(String path) async {
   if (!_files.containsKey(path)) {
      throw Exception('File not found: $path');
    }
    return _files[path]!;
  }

  @override
  Future<void> delete(String path) async {
    _files.remove(path);
  }

  // Additional method for testing
  void clear() {
    _files.clear();
  }
}
