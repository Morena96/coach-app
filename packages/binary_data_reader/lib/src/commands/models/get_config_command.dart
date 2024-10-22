import 'dart:typed_data';

import 'package:binary_data_reader/src/commands/models/stv4_base_command.dart';
import 'package:binary_data_reader/src/commands/command_types.dart';

class GetConfigCommand extends Stv4BaseCommand {
  static const int _commandId = CommandTypes.GET_CONFIG;
  int masterId;
  int frequency;
  int mainFrequency;
  bool isMain;
  int clubId;

  @override
  int get commandId => _commandId;

  @override
  Uint8List generatePayload() => Uint8List(0);

  GetConfigCommand({
    required this.masterId,
    required this.frequency,
    required this.mainFrequency,
    required this.isMain,
    required this.clubId,
  });
}
