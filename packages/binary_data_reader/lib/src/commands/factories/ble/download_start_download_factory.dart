import 'dart:typed_data';
import 'package:binary_data_reader/src/commands/command_factory.dart';
import 'package:binary_data_reader/src/commands/models/ble/download_start_download.dart';

class DownloadStartDownloadCommandFactory
    implements CommandFactory<DownloadStartDownloadCommand> {
  @override
  DownloadStartDownloadCommand fromBinary(Uint8List data) {
    // first 4 bytes are startTimestamp
    final startTimestamp = data.buffer.asByteData().getUint32(0, Endian.big);

    // next 4 bytes are endTimestamp
    final endTimestamp = data.buffer.asByteData().getUint32(4, Endian.big);

    return DownloadStartDownloadCommand(
        startTimestamp: startTimestamp, endTimestamp: endTimestamp);
  }

  @override
  DownloadStartDownloadCommand fromProperties(Map<String, dynamic> properties) {
    return DownloadStartDownloadCommand(
        startTimestamp: properties['startTimestamp'],
        endTimestamp: properties['endTimestamp']);
  }
}
