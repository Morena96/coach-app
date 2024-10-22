
import 'dart:typed_data';
import 'package:binary_data_reader/src/commands/command_factory.dart';
import 'package:binary_data_reader/src/commands/models/ble/download_get_crash_log.dart';

class DownloadGetCrashLogCommandFactory implements CommandFactory<DownloadGetCrashLogCommand> {
    @override
    DownloadGetCrashLogCommand fromBinary(Uint8List data) {
      return DownloadGetCrashLogCommand();
    }

    @override
    DownloadGetCrashLogCommand fromProperties(Map<String, dynamic> properties) {
      return DownloadGetCrashLogCommand();
    }
}
