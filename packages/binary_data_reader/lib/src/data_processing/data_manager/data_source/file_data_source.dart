import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:binary_data_reader/src/data_processing/data_manager/data_source/data_source.dart';

class FileDataSource extends DataSource {
  final String filePath;
  late StreamController<Uint8List> _streamController;
  late File _file;

  FileDataSource(this.filePath) {
    _file = File(filePath);
    _streamController = StreamController<Uint8List>();
  }

  @override
  Stream<Uint8List> get dataStream => _streamController.stream;

  @override
  Future<void> initialize() async {
    print('initializing file source');
    try {
      print('attempting');
      // Ensure the file exists before attempting to read
      if (await _file.exists()) {
        // Open the file for reading
        final fileStream = _file.openRead();
        // Pipe file stream into the stream controller
        fileStream.listen(
          (data) async {
            _streamController.add(Uint8List.fromList(data));
          },
          onError: (error) => _streamController.addError(error),
          onDone: () => _streamController.close(),
          cancelOnError: true,
        );
      } else {
        print('file not found');
        throw FileSystemException("File not found", filePath);
      }
    } catch (e) {
      print('error initializing file source');
      print(e.toString());
      // Handle initialization errors, such as file not found
      _streamController.addError(e);
      await dispose();
    }
  }

  @override
  Future<void> dispose() async {
    await _streamController.close();
  }
}
