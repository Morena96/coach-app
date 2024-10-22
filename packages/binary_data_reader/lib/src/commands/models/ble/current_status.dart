import 'dart:typed_data';

import 'package:binary_data_reader/main.dart';
import 'package:binary_data_reader/src/commands/command_types.dart';

class CurrentStatusCommand extends Stv4BaseCommand {
  int deviceId;
  int charge;
  int batteryPercent;
  int fwVersionMajor;
  int fwVersionMinor;
  int fwVersionPatch;
  int mode;

  static const int _commandId = BLECommandTypes.CURRENT_STATUS;

  @override
  int get commandId => _commandId;

  CurrentStatusCommand({
    required this.deviceId,
    required this.charge,
    required this.batteryPercent,
    required this.fwVersionMajor,
    required this.fwVersionMinor,
    required this.fwVersionPatch,
    required this.mode,
  });

  @override
  Uint8List generatePayload() {
    return Uint8List(0);
  }

  @override
  String toString() {
    return 'CurrentStatusCommand{deviceId: $deviceId, charge: $charge, batteryPercent: $batteryPercent, fwVersionMajor: $fwVersionMajor, fwVersionMinor: $fwVersionMinor, fwVersionPatch: $fwVersionPatch, mode: $mode}';
  }
}
