import 'package:domain/features/logging/entities/log_entry.dart';

/// Defines the interface for writing, reading, and clearing logs from persistent storage or memory.
abstract class LogPersistenceManager {
  /// Writes a log entry to storage.
  Future<void> writeLog(LogEntry entry);

  /// Reads all log entries from storage.
  Future<List<LogEntry>> readLogs();

  /// Clears all log entries from storage.
  Future<void> clearLogs();

  /// Reads log entries filtered by log level.
  Future<List<LogEntry>> readLogsByLevel(LogLevel level);

  /// Reads log entries within a specific date range.
  Future<List<LogEntry>> readLogsByDateRange(DateTime start, DateTime end);

  /// Gets the total number of log entries in storage.
  Future<int> getLogCount();

  /// Deletes log entries older than a specified date.
  Future<void> deleteOldLogs(DateTime cutoffDate);
}
