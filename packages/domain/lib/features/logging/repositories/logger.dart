import 'package:domain/features/logging/entities/log_entry.dart';

/// Defines the interface for logger implementations.
abstract class LoggerRepository {
  /// Logs a debug message.
  void debug(String message);

  /// Logs an informational message.
  void info(String message);

  /// Logs a warning message.
  void warning(String message);

  /// Logs an error message, optionally with an associated error object and stack trace.
  void error(String message, [dynamic error, StackTrace? stackTrace]);

  /// Provides a stream of log messages.
  Stream<LogEntry> get logStream;

  /// Reads log entries from storage by page.
  ///
  /// [page] - The page number to read.
  /// [pageSize] - The number of log entries per page.
  Future<List<LogEntry>> getLogsByPage(int page, int pageSize);
}
