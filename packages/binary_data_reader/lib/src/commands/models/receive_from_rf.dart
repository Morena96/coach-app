import 'dart:typed_data';

import 'package:binary_data_reader/src/commands/models/stv4_base_command.dart';
import 'package:binary_data_reader/src/commands/command_types.dart';

class ReceiveFromRfCommand extends Stv4BaseCommand {
  static const int _commandId = CommandTypes.RECEIVE_FROM_RF;

  @override
  int get commandId => _commandId;

  @override
  Uint8List generatePayload() => Uint8List(0);
}
