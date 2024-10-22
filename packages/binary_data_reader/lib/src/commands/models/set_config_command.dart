import 'dart:typed_data';

import 'package:binary_data_reader/src/commands/models/stv4_base_command.dart';
import 'package:binary_data_reader/src/commands/command_types.dart';

class SetConfigCommand extends Stv4BaseCommand {
  static const int _commandId = CommandTypes.SET_CONFIG;
  int? masterId;
  int? frequency;
  int? mainFrequency;
  bool? isMain;
  int? clubId;

  @override
  int get commandId => _commandId;

  @override
  Uint8List generatePayload() {
    ByteData payload = ByteData(6);

    if (masterId != null) {
      payload.setUint8(0, masterId!);
    }
    if (frequency != null) {
      payload.setUint8(1, frequency!);
    }
    if (mainFrequency != null) {
      payload.setUint8(2, mainFrequency!);
    }
    if (isMain != null) {
      payload.setUint8(3, isMain! ? 1 : 0);
    }
    if (clubId != null) {
      payload.setInt16(4, clubId!);
    }

    return payload.buffer.asUint8List();
  }

  SetConfigCommand({
    this.masterId,
    this.frequency,
    this.mainFrequency,
    this.isMain,
    this.clubId,
  });
}
