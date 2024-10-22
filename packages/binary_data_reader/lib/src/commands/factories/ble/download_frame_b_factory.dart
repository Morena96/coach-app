import 'dart:typed_data';

import 'package:binary_data_reader/src/commands/command_factory.dart';
import 'package:binary_data_reader/src/commands/models/ble/download_frame_b.dart';

class DownloadFrameBFactory implements CommandFactory {
  @override
  DownloadFrameB fromBinary(Uint8List data) {
    return DownloadFrameB(
      data: data,
    );
  }

  @override
  DownloadFrameB fromProperties(Map<String, dynamic> properties) {
    return DownloadFrameB(
      data: properties['data'],
    );
  }
}
