import 'dart:typed_data';

import 'package:binary_data_reader/main.dart';
import 'package:binary_data_reader/src/commands/command_types.dart';

class SetNameCommand extends Stv4BaseCommand {
  int name;

  static const int _commandId = BLECommandTypes.SET_NAME;

  @override
  int get commandId => _commandId;

  SetNameCommand({
    required this.name,
  });

  @override
  Uint8List generatePayload() {
    // convert the name to ascii ints
    List<int> asciiName = name.toString().codeUnits;

    // create a Uint8List with the length of the asciiName
    Uint8List payload = Uint8List(asciiName.length);

    // copy the asciiName to the payload
    for (int i = 0; i < asciiName.length; i++) {
      payload[i] = asciiName[i];
    }

    return payload;
  }

  @override
  String toString() {
    return 'SetNameCommand{name: $name}';
  }
}
