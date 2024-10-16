import 'package:domain/features/logging/entities/log_entry.dart';
import 'package:domain/features/logging/repositories/log_persistence_manager.dart';

class InMemoryLoggerPersistenceManagerImpl implements LogPersistenceManager {
  final List<LogEntry> _logs = [];

  @override
  Future<void> writeLog(LogEntry entry) async {
    _logs.add(entry);
  }

  @override
  Future<List<LogEntry>> readLogs() async {
    return List.from(_logs);
  }

  @override
  Future<void> clearLogs() async {
    _logs.clear();
  }

  @override
  Future<List<LogEntry>> readLogsByLevel(LogLevel level) async {
    return _logs.where((entry) => entry.level == level).toList();
  }

  @override
  Future<List<LogEntry>> readLogsByDateRange(DateTime start, DateTime end) async {
    return _logs
        .where((entry) => entry.timestamp.isAfter(start) && entry.timestamp.isBefore(end))
        .toList();
  }

  @override
  Future<int> getLogCount() async {
    return _logs.length;
  }

  @override
  Future<void> deleteOldLogs(DateTime cutoffDate) async {
    _logs.removeWhere((entry) => entry.timestamp.isBefore(cutoffDate));
  }
}
