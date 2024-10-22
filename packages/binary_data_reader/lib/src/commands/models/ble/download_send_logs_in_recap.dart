
import 'dart:typed_data';
import 'package:binary_data_reader/main.dart';
import 'package:binary_data_reader/src/commands/command_types.dart';

class DownloadSendLogsInRecapCommand extends Stv4BaseCommand {
  @override
  int get commandId => BLECommandTypes.DOWNLOAD_SEND_LOGS_IN_RECAP;

  @override
  Uint8List generatePayload() {
   return Uint8List(0);
  }
}
