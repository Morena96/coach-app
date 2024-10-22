import 'dart:typed_data';

import 'package:binary_data_reader/src/data_processing/storage_adapter/storage_adapter.dart';

class NullStorageAdapter implements StorageAdapter {
  @override
  Future<void> initialize() async {
    // No operation
  }

  @override
  Future<void> write(Uint8List data) async {
    // No operation
  }

  @override
  Future<void> finalize() async {
    // No operation
  }

  @override
  String getFilePath() {
    return '';
  }
}
