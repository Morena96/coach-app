import 'package:coach_app/shared/logging/infrastructure/repositories/in_memory_logger_persistence_manager_impl.dart';
import 'package:domain/features/logging/repositories/logger.dart';
import 'package:coach_app/shared/services/logging/mock_logger.dart';
import 'package:coach_app/shared/services/logging/talker_logger.dart';
import 'package:talker_flutter/talker_flutter.dart' show Talker;

enum LoggerType {
  talker,
  mock,
  unknown
}

class LoggerFactory {
  static LoggerRepository createLogger(LoggerType type) {
    switch (type) {
      case LoggerType.talker:
        return TalkerLogger(Talker(), InMemoryLoggerPersistenceManagerImpl());
      case LoggerType.mock:
        return MockLogger();
      // Add cases for other logger types here
      default:
        throw ArgumentError('Unknown logger type: $type');
    }
  }
}
