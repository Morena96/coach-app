import 'dart:typed_data';
import 'package:binary_data_reader/main.dart';
import 'package:binary_data_reader/src/commands/command_types.dart';

class DownloadStartDownloadCommand extends Stv4BaseCommand {
  final int startTimestamp;
  final int endTimestamp;

  DownloadStartDownloadCommand({
    required this.startTimestamp,
    required this.endTimestamp,
  });

  @override
  int get commandId => BLECommandTypes.DOWNLOAD_START_DOWNLOAD;

  @override
  Uint8List generatePayload() {
    ByteData payload = ByteData(8);

    payload.setUint32(0, startTimestamp, Endian.big);
    payload.setUint32(4, endTimestamp, Endian.big);

    return payload.buffer.asUint8List();
  }

  @override
  String toString() {
    return 'DownloadStartDownloadCommand{startTimestamp: $startTimestamp, endTimestamp: $endTimestamp}';
  }
}
