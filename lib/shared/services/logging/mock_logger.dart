import 'package:domain/features/logging/entities/log_entry.dart';
import 'package:domain/features/logging/repositories/logger.dart';

class MockLogger implements LoggerRepository {
  final List<LogEntry> logs = [];

  @override
  void debug(String message) => logs.add(LogEntry(level: LogLevel.debug, message: message));

  @override
  void info(String message) => logs.add(LogEntry(level: LogLevel.info, message: message));

  @override
  void warning(String message) => logs.add(LogEntry(level: LogLevel.warning, message: message));

  @override
  void error(String message, [dynamic error, StackTrace? stackTrace]) =>
      logs.add(LogEntry(level: LogLevel.error, message: message, error: error, stackTrace: stackTrace));

  @override
  Stream<LogEntry> get logStream => Stream.fromIterable(logs);
}
