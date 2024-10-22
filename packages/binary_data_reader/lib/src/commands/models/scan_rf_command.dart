import 'dart:typed_data';

import 'package:binary_data_reader/src/commands/command_types.dart';
import 'package:binary_data_reader/src/commands/models/stv4_base_command.dart';
import 'package:binary_data_reader/src/utils/generate_single_byte_list_from_integer.dart';

class ScanRfCommand extends Stv4BaseCommand {
  int frequency;
  List<int> rssiData = [];
  final int _commandId = CommandTypes.SCAN_RF;

  @override
  int get commandId => _commandId;

  @override
  Uint8List generatePayload() => generateSingleByteFromAnInteger(frequency);

  ScanRfCommand({
    required this.frequency,
    required this.rssiData,
  });
}
