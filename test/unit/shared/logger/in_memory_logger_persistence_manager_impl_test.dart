import 'package:flutter_test/flutter_test.dart';
import 'package:coach_app/shared/logging/infrastructure/repositories/in_memory_logger_persistence_manager_impl.dart';
import 'package:domain/features/logging/entities/log_entry.dart';

void main() {
  group('InMemoryLoggerPersistenceManagerImpl', () {
    late InMemoryLoggerPersistenceManagerImpl persistenceManager;

    setUp(() {
      persistenceManager = InMemoryLoggerPersistenceManagerImpl();
    });

    test('writeLog should add a log entry', () async {
      final logEntry = LogEntry(
        level: LogLevel.info,
        message: 'Test log',
        timestamp: DateTime.now(),
      );

      await persistenceManager.writeLog(logEntry);

      final logs = await persistenceManager.readLogs();
      expect(logs.length, 1);
      expect(logs.first.message, 'Test log');
    });

    test('readLogs should return all logs', () async {
      final logEntries = [
        LogEntry(level: LogLevel.debug, message: 'Debug log', timestamp: DateTime.now()),
        LogEntry(level: LogLevel.info, message: 'Info log', timestamp: DateTime.now()),
        LogEntry(level: LogLevel.warning, message: 'Warning log', timestamp: DateTime.now()),
      ];

      for (var entry in logEntries) {
        await persistenceManager.writeLog(entry);
      }

      final logs = await persistenceManager.readLogs();
      expect(logs.length, 3);
      expect(logs.map((e) => e.message), ['Debug log', 'Info log', 'Warning log']);
    });

    test('clearLogs should remove all logs', () async {
      await persistenceManager.writeLog(LogEntry(level: LogLevel.info, message: 'Test log', timestamp: DateTime.now()));
      await persistenceManager.clearLogs();

      final logs = await persistenceManager.readLogs();
      expect(logs.isEmpty, true);
    });

    test('readLogsByLevel should return logs of specified level', () async {
      await persistenceManager.writeLog(LogEntry(level: LogLevel.debug, message: 'Debug log', timestamp: DateTime.now()));
      await persistenceManager.writeLog(LogEntry(level: LogLevel.info, message: 'Info log', timestamp: DateTime.now()));
      await persistenceManager.writeLog(LogEntry(level: LogLevel.warning, message: 'Warning log', timestamp: DateTime.now()));

      final infoLogs = await persistenceManager.readLogsByLevel(LogLevel.info);
      expect(infoLogs.length, 1);
      expect(infoLogs.first.message, 'Info log');
    });

    test('readLogsByDateRange should return logs within specified range', () async {
      final now = DateTime.now();
      await persistenceManager.writeLog(LogEntry(level: LogLevel.info, message: 'Old log', timestamp: now.subtract(const Duration(days: 2))));
      await persistenceManager.writeLog(LogEntry(level: LogLevel.info, message: 'Recent log', timestamp: now.subtract(const Duration(hours: 1))));
      await persistenceManager.writeLog(LogEntry(level: LogLevel.info, message: 'Future log', timestamp: now.add(const Duration(days: 1))));

      final logs = await persistenceManager.readLogsByDateRange(now.subtract(const Duration(days: 1)), now);
      expect(logs.length, 1);
      expect(logs.first.message, 'Recent log');
    });

    test('getLogCount should return correct number of logs', () async {
      await persistenceManager.writeLog(LogEntry(level: LogLevel.info, message: 'Log 1', timestamp: DateTime.now()));
      await persistenceManager.writeLog(LogEntry(level: LogLevel.info, message: 'Log 2', timestamp: DateTime.now()));

      final count = await persistenceManager.getLogCount();
      expect(count, 2);
    });

    test('deleteOldLogs should remove logs older than cutoff date', () async {
      final now = DateTime.now();
      await persistenceManager.writeLog(LogEntry(level: LogLevel.info, message: 'Old log', timestamp: now.subtract(const Duration(days: 2))));
      await persistenceManager.writeLog(LogEntry(level: LogLevel.info, message: 'Recent log', timestamp: now.subtract(const Duration(hours: 1))));

      await persistenceManager.deleteOldLogs(now.subtract(const Duration(days: 1)));

      final logs = await persistenceManager.readLogs();
      expect(logs.length, 1);
      expect(logs.first.message, 'Recent log');
    });
  });
}
