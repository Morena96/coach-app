
import 'dart:typed_data';
import 'package:binary_data_reader/src/commands/command_factory.dart';
import 'package:binary_data_reader/src/commands/models/ble/download_get_current_block_logs.dart';

class DownloadGetCurrentBlockLogsCommandFactory implements CommandFactory<DownloadGetCurrentBlockLogsCommand> {
    @override
    DownloadGetCurrentBlockLogsCommand fromBinary(Uint8List data) {
      return DownloadGetCurrentBlockLogsCommand();
    }

    @override
    DownloadGetCurrentBlockLogsCommand fromProperties(Map<String, dynamic> properties) {
      return DownloadGetCurrentBlockLogsCommand();
    }
}
