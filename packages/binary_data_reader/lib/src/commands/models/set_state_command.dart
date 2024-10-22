import 'dart:typed_data';

import 'package:binary_data_reader/src/commands/models/stv4_base_command.dart';
import 'package:binary_data_reader/src/commands/command_types.dart';
import 'package:binary_data_reader/src/models/sensor_mode.dart';

class SetStateCommand extends Stv4BaseCommand {
  static const int _commandId = CommandTypes.SET_STATE;
  List<SensorMode> rfSlotStates; // Holds the state for each RF slot

  @override
  int get commandId => _commandId;

  @override
  Uint8List generatePayload() {
    final payload = Uint8List(15); // Initialize payload with 15 bytes
    for (int i = 0; i < 15; i++) {
      // Fill each byte with the corresponding mode value, default to 0xFF (Unused) for any missing slots
      payload[i] = i < rfSlotStates.length ? rfSlotStates[i].value : 0xFF;
    }
    return payload;
  }

  SetStateCommand({required this.rfSlotStates});
}
