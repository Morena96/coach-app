import 'dart:typed_data';
import 'package:binary_data_reader/src/commands/command_factory.dart';
import 'package:binary_data_reader/src/commands/models/send_then_receive_command.dart';
import 'package:binary_data_reader/src/commands/models/command.dart';

class SendThenReceiveCommandFactory extends CommandFactory {
  @override
  Command fromBinary(Uint8List data) {
    SendThenReceiveCommand command = SendThenReceiveCommand();
    command.setArbitraryPayload(data);
    return command;
  }

  @override
  Command fromProperties(Map<String, dynamic> properties) {
    SendThenReceiveCommand cmd = SendThenReceiveCommand();
    cmd.setArbitraryPayload(properties['payload']);
    return cmd;
  }
}
