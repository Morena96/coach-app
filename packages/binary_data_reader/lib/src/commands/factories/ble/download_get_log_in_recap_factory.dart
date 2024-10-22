
import 'dart:typed_data';
import 'package:binary_data_reader/src/commands/command_factory.dart';
import 'package:binary_data_reader/src/commands/models/ble/download_get_log_in_recap.dart';

class DownloadGetLogInRecapCommandFactory implements CommandFactory<DownloadGetLogInRecapCommand> {
    @override
    DownloadGetLogInRecapCommand fromBinary(Uint8List data) {
      return DownloadGetLogInRecapCommand();
    }

    @override
    DownloadGetLogInRecapCommand fromProperties(Map<String, dynamic> properties) {
      return DownloadGetLogInRecapCommand();
    }
}
