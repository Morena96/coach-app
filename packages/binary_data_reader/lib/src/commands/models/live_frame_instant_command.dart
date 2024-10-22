import 'dart:typed_data';

import 'package:binary_data_reader/src/commands/models/stv4_base_command.dart';
import 'package:binary_data_reader/src/commands/command_types.dart';

class LiveFrameInstantCommand extends Stv4BaseCommand {
  int instantTimestamp;
  int instantNanos;
  double instantVelocity;
  double instantLatitude;
  double instantLongitude;

  static const int _commandId = CommandTypes.LIVE;

  @override
  int get commandId => _commandId;

  // live frame command doesn't send any payload to the chip
  @override
  Uint8List generatePayload() => Uint8List(0);

  LiveFrameInstantCommand({
    required this.instantTimestamp,
    required this.instantNanos,
    required this.instantVelocity,
    required this.instantLatitude,
    required this.instantLongitude,
  });

  @override
  String toString() {
    return 'LiveFrameInstantCommand{instantTimestamp: $instantTimestamp, instantNanos: $instantNanos, instantVelocity: $instantVelocity, instantLatitude: $instantLatitude, instantLongitude: $instantLongitude}';
  }
}
