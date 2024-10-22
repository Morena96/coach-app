import 'dart:typed_data';

import 'package:binary_data_reader/src/commands/models/command.dart';

abstract class CommandFactory<T extends Command> {
  T fromBinary(Uint8List data);
  T fromProperties(Map<String, dynamic> properties);
}
