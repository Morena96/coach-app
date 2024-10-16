import 'dart:async';

import 'package:binary_data_reader/main.dart';
import 'package:domain/features/antenna_system/repositories/command_source.dart';

class ReceiveCommandsUseCase {
  final CommandSource _commandSource;

  ReceiveCommandsUseCase(this._commandSource);

  Stream<Command> execute() {
    return _commandSource.getCommands();
  }
}
