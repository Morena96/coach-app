import 'dart:typed_data';

import 'package:binary_data_reader/main.dart';
import 'package:binary_data_reader/src/commands/command_types.dart';

class GetStatusCommand extends Stv4BaseCommand {
  static const int _commandId = BLECommandTypes.GET_STATUS;

  @override
  int get commandId => _commandId;

  GetStatusCommand();

  @override
  Uint8List generatePayload() {
    return Uint8List(0);
  }

  @override
  String toString() {
    return 'GetStatusCommand{}';
  }
}
