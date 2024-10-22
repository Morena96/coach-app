import 'dart:io';
import 'dart:typed_data';

import 'package:binary_data_reader/src/data_processing/storage_adapter/storage_adapter.dart';

enum StorageFormat { binary, hex, text }

class LocalStorageAdapter implements StorageAdapter {
  final File _file;
  IOSink? _sink;
  final StorageFormat format;

  LocalStorageAdapter(this._file, {this.format = StorageFormat.binary});

  @override
  String getFilePath() {
    return _file.path;
  }

  @override
  Future<void> initialize() async {
    await _file.create(recursive: true);
    print('File created: ${_file.absolute.path}');
    _sink = _file.openWrite(mode: FileMode.append);
  }

  @override
  Future<void> write(Uint8List data) async {
    if (_sink != null) {
      switch (format) {
        case StorageFormat.hex:
          String hexString = data
              .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
              .join(' ');
          _sink?.writeln(hexString);
          break;
        case StorageFormat.text:
          String textString = String.fromCharCodes(data);
          _sink?.writeln(textString);
          break;
        case StorageFormat.binary:
        default:
          _sink?.add(data);
          break;
      }
    }
  }

  @override
  Future<void> finalize() async {
    if (_sink != null) {
      await _sink!.flush();
      await _sink!.close();
      _sink = null; // Reset sink to prevent reuse after closing
    }
  }
}
