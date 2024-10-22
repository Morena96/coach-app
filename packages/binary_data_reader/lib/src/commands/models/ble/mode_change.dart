import 'dart:typed_data';

import 'package:binary_data_reader/main.dart';
import 'package:binary_data_reader/src/commands/command_types.dart';

class ModeChangeCommand extends Stv4BaseCommand {
  int lastMode;
  int currentMode;

  static const int _commandId = BLECommandTypes.MODE_CHANGE;

  @override
  int get commandId => _commandId;

  ModeChangeCommand({
    required this.lastMode,
    required this.currentMode,
  });

  @override
  Uint8List generatePayload() {
    return Uint8List(0);
  }

  @override
  String toString() {
    return 'ModeChangeCommand{lastMode: $lastMode, newMode: $currentMode}';
  }
}
