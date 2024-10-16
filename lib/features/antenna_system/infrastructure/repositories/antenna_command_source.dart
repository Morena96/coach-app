import 'dart:async';

import 'package:binary_data_reader/main.dart';
import 'package:domain/features/antenna_system/repositories/antenna_data_repository.dart';
import 'package:domain/features/antenna_system/repositories/command_source.dart';

class AntennaCommandSource implements CommandSource {
  final AntennaDataRepository _repository;
  final FramesParser _framesParser;
  final FramesProcessor _framesProcessor;

  AntennaCommandSource(
      this._repository, this._framesParser, this._framesProcessor);

  @override
  Stream<Command> getCommands() {
    return _framesProcessor.process(
        _framesParser.parse(_repository.getAllDataStreams().map((data) {
      final (_, bytes) = data;
      return bytes;
    })));
  }
}
