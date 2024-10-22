
import 'dart:typed_data';
import 'package:binary_data_reader/src/commands/command_factory.dart';
import 'package:binary_data_reader/src/commands/models/ble/download_send_logs_in_recap_second.dart';

class DownloadSendLogsInRecapSecondCommandFactory implements CommandFactory<DownloadSendLogsInRecapSecondCommand> {
    @override
    DownloadSendLogsInRecapSecondCommand fromBinary(Uint8List data) {
      return DownloadSendLogsInRecapSecondCommand();
    }

    @override
    DownloadSendLogsInRecapSecondCommand fromProperties(Map<String, dynamic> properties) {
      return DownloadSendLogsInRecapSecondCommand();
    }
}
