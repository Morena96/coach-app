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

    test('readLogsByPage should return correct logs for each page', () async {
      // Populate the log with 25 entries
      for (int i = 0; i < 25; i++) {
        await persistenceManager.writeLog(LogEntry(
          level: LogLevel.info,
          message: 'Log $i',
          timestamp: DateTime.now(),
        ));
      }

      // Test first page (0-based index)
      final firstPage = await persistenceManager.readLogsByPage(0, 10);
      expect(firstPage.length, 10);
      expect(firstPage.first.message, 'Log 0');
      expect(firstPage.last.message, 'Log 9');

      // Test second page
      final secondPage = await persistenceManager.readLogsByPage(1, 10);
      expect(secondPage.length, 10);
      expect(secondPage.first.message, 'Log 10');
      expect(secondPage.last.message, 'Log 19');

      // Test last page (partial)
      final lastPage = await persistenceManager.readLogsByPage(2, 10);
      expect(lastPage.length, 5);
      expect(lastPage.first.message, 'Log 20');
      expect(lastPage.last.message, 'Log 24');

      // Test empty page
      final emptyPage = await persistenceManager.readLogsByPage(3, 10);
      expect(emptyPage.isEmpty, true);
    });

    test('readLogsByPage should handle empty log list', () async {
      final emptyPage = await persistenceManager.readLogsByPage(0, 10);
      expect(emptyPage.isEmpty, true);
    });

    test('readLogsByPage should handle page size larger than total logs', () async {
      // Add 5 logs
      for (int i = 0; i < 5; i++) {
        await persistenceManager.writeLog(LogEntry(
          level: LogLevel.info,
          message: 'Log $i',
          timestamp: DateTime.now(),
        ));
      }

      final page = await persistenceManager.readLogsByPage(0, 10);
      expect(page.length, 5);
      expect(page.first.message, 'Log 0');
      expect(page.last.message, 'Log 4');
    });
  });
}
