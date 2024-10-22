
import 'dart:typed_data';
import 'package:binary_data_reader/src/commands/command_factory.dart';
import 'package:binary_data_reader/src/commands/models/ble/download_send_logs_in_recap.dart';

class DownloadSendLogsInRecapCommandFactory implements CommandFactory<DownloadSendLogsInRecapCommand> {
    @override
    DownloadSendLogsInRecapCommand fromBinary(Uint8List data) {
      return DownloadSendLogsInRecapCommand();
    }

    @override
    DownloadSendLogsInRecapCommand fromProperties(Map<String, dynamic> properties) {
      return DownloadSendLogsInRecapCommand();
    }
}
