import 'package:coach_app/shared/logging/infrastructure/data/hive_log_entry_adapter.dart';
import 'package:coach_app/shared/logging/infrastructure/data/hive_log_level_adapter.dart';
import 'package:domain/features/logging/entities/log_entry.dart';
import 'package:domain/features/logging/repositories/log_persistence_manager.dart';
import 'package:hive/hive.dart';

class HiveLoggerManagerImpl implements LogPersistenceManager {
  static const String _boxName = 'logs';
  late Box<HiveLogEntry> _box;

  Future<void> init() async {
    Hive.registerAdapter(HiveLogEntryAdapter());
    Hive.registerAdapter(HiveLogLevelAdapter());
    _box = await Hive.openBox<HiveLogEntry>(_boxName);
  }

  @override
  Future<void> writeLog(LogEntry entry) async {
    final hiveEntry = HiveLogEntry(
      level: HiveLogLevel.values[entry.level.index],
      message: entry.message,
      timestamp: entry.timestamp,
      error: entry.error?.toString(),
      stackTrace: entry.stackTrace?.toString(),
    );
    await _box.add(hiveEntry);
  }

  @override
  Future<List<LogEntry>> readLogs() async {
    return _box.values.map(_convertHiveLogEntryToLogEntry).toList();
  }

  @override
  Future<void> clearLogs() async {
    await _box.clear();
  }

  @override
  Future<List<LogEntry>> readLogsByLevel(LogLevel level) async {
    return _box.values
        .where((entry) => entry.level == HiveLogLevel.values[level.index])
        .map(_convertHiveLogEntryToLogEntry)
        .toList();
  }

  @override
  Future<List<LogEntry>> readLogsByDateRange(DateTime start, DateTime end) async {
    return _box.values
        .where((entry) => entry.timestamp.isAfter(start) && entry.timestamp.isBefore(end))
        .map(_convertHiveLogEntryToLogEntry)
        .toList();
  }

  @override
  Future<int> getLogCount() async {
    return _box.length;
  }

  @override
  Future<void> deleteOldLogs(DateTime cutoffDate) async {
    final keysToDelete = _box.keys.where((key) {
      final entry = _box.get(key);
      return entry != null && entry.timestamp.isBefore(cutoffDate);
    }).toList();

    await _box.deleteAll(keysToDelete);
  }

  LogEntry _convertHiveLogEntryToLogEntry(HiveLogEntry hiveEntry) {
    return LogEntry(
      level: LogLevel.values[hiveEntry.level.index],
      message: hiveEntry.message,
      timestamp: hiveEntry.timestamp,
      error: hiveEntry.error,
      stackTrace: hiveEntry.stackTrace != null ? StackTrace.fromString(hiveEntry.stackTrace!) : null,
    );
  }
}
