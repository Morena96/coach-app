
import 'dart:typed_data';
import 'package:binary_data_reader/main.dart';
import 'package:binary_data_reader/src/commands/command_types.dart';

class StopLiveModeCommand extends Stv4BaseCommand {
  @override
  int get commandId => BLECommandTypes.STOP_LIVE_MODE;

  @override
  Uint8List generatePayload() {
   return Uint8List(0);
  }
}
