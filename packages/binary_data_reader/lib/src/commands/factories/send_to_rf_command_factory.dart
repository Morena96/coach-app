import 'dart:typed_data';
import 'package:binary_data_reader/src/commands/command_factory.dart';
import 'package:binary_data_reader/src/commands/models/send_to_rf_command.dart';
import 'package:binary_data_reader/src/commands/models/command.dart';

class SendToRfCommandFactory extends CommandFactory {
  @override
  Command fromBinary(Uint8List data) {
    SendToRfCommand command = SendToRfCommand();
    command.setArbitraryPayload(data);
    return command;
  }

  @override
  Command fromProperties(Map<String, dynamic> properties) {
    SendToRfCommand cmd = SendToRfCommand();
    cmd.setArbitraryPayload(properties['payload']);
    return cmd;
  }
}
