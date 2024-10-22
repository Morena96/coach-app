import 'dart:typed_data';

import 'package:binary_data_reader/src/commands/command_factory.dart';
import 'package:binary_data_reader/src/commands/models/ble/download_frame_a.dart';

class DownloadFrameAFactory implements CommandFactory {
  @override
  DownloadFrameA fromBinary(Uint8List data) {
    return DownloadFrameA(
      data: data,
    );
  }

  @override
  DownloadFrameA fromProperties(Map<String, dynamic> properties) {
    return DownloadFrameA(
      data: properties['data'],
    );
  }
}
