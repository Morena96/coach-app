import 'package:domain/features/logging/repositories/logger.dart';
import 'package:coach_app/shared/services/logging/logger_factory.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'logger_provider.g.dart';

@Riverpod(keepAlive: true)
LoggerRepository logger(LoggerRef ref) {
  // Define the logger type, can change this depending on environment
  const loggerType = LoggerType.talker;

  // Create and return the logger
  return LoggerFactory.createLogger(loggerType);
}
