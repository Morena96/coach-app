import 'dart:typed_data';
import 'package:binary_data_reader/src/commands/command_factory.dart';
import 'package:binary_data_reader/src/commands/models/receive_from_rf.dart';
import 'package:binary_data_reader/src/commands/models/command.dart';

class ReceiveFromRfFactory extends CommandFactory {
  @override
  Command fromBinary(Uint8List data) {
    return ReceiveFromRfCommand();
  }

  @override
  Command fromProperties(Map<String, dynamic> properties) {
    return ReceiveFromRfCommand();
  }
}
