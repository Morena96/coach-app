import 'package:binary_data_reader/main.dart';
import 'package:domain/features/antenna_system/repositories/antenna_command_repository.dart';
import 'package:domain/features/logging/repositories/logger.dart';

class AntennaContext {
  final AntennaCommandRepository repository;
  final FrameParsingStrategy parsingStrategy;
  final LoggerRepository logger;

  AntennaContext({
    required this.repository,
    required this.parsingStrategy,
    required this.logger,
  });
}
