import 'dart:typed_data';

import 'package:binary_data_reader/main.dart';
import 'package:binary_data_reader/src/commands/command_types.dart';

class DownloadFrameA extends Stv4BaseCommand {

  final Uint8List data;

  DownloadFrameA({
    required this.data,
  });

  @override
  int get commandId => BLECommandTypes.DOWNLOAD_FRAME_B;

  @override
  Uint8List generatePayload() {
    return Uint8List(0);
  }
}
