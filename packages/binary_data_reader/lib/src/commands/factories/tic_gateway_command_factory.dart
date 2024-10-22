import 'dart:typed_data';
import 'package:binary_data_reader/src/commands/command_factory.dart';
import 'package:binary_data_reader/src/commands/models/tic_gateway_command.dart';
import 'package:binary_data_reader/src/commands/models/command.dart';
class TicGatewayCommandFactory extends CommandFactory {
  @override
  Command fromBinary(Uint8List data) {
    return TicGatewayCommand();
  }

  @override
  Command fromProperties(Map<String, dynamic> properties) {
    return TicGatewayCommand();
  }
}