import 'dart:io';
import 'dart:typed_data';

import 'file_system.dart';

/// Implements [FileSystemService] using the IO library for file system operations.
class IoFileSystemService implements FileSystemService {
  @override
  Future<String> write(String path, Uint8List data) async {
    final file = File(path);
    await file.create(recursive: true);
    await file.writeAsBytes(data);
    return path;
  }

  @override
  Future<bool> exists(String path) async {
    return File(path).exists();
  }

  @override
  Future<Uint8List> read(String path) async {
    final file = File(path);
    return await file.readAsBytes();
  }

  @override
  Future<void> delete(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }
}
