import 'dart:async';

import 'package:coach_app/shared/services/logging/talker_logger.dart';
import 'package:domain/features/logging/entities/log_entry.dart' as domain_logs;
import 'package:domain/features/logging/repositories/log_persistence_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:talker_flutter/talker_flutter.dart'
    show Talker, TalkerData, LogLevel;

@GenerateMocks(
  [LogPersistenceManager],
  customMocks: [
    MockSpec<Talker>(unsupportedMembers: {#configure})
  ],
)
import 'talker_logger_test.mocks.dart';

void main() {
  group('TalkerLogger', () {
    late MockTalker mockTalker;
    late MockLogPersistenceManager mockPersistenceManager;
    late TalkerLogger talkerLogger;
    late StreamController<TalkerData> streamController;

    setUp(() {
      mockTalker = MockTalker();
      mockPersistenceManager = MockLogPersistenceManager();
      streamController = StreamController<TalkerData>.broadcast();
      when(mockTalker.stream).thenAnswer((_) => streamController.stream);
      talkerLogger = TalkerLogger(mockTalker, mockPersistenceManager);
    });

    tearDown(() {
      streamController.close();
    });

    test('_handleTalkerLog processes TalkerData correctly', () async {
      final testError = ArgumentError('Test error');
      final testStackTrace = StackTrace.current;
      final talkerData = TalkerData('Test log message',
          logLevel: LogLevel.info, error: testError, stackTrace: testStackTrace);

      streamController.add(talkerData);

      await expectLater(
        talkerLogger.logStream,
        emits(predicate<domain_logs.LogEntry>((entry) =>
            entry.level == domain_logs.LogLevel.info &&
            entry.message == 'Test log message' &&
            entry.error == testError &&
            entry.stackTrace == testStackTrace)),
      );

      verify(mockPersistenceManager.writeLog(any)).called(1);
    });

    test('_handleTalkerLog handles different log levels', () async {
      final logLevels = [
        LogLevel.debug,
        LogLevel.info,
        LogLevel.warning,
        LogLevel.error,
        LogLevel.critical,
        LogLevel.verbose,
      ];

      for (var level in logLevels) {
        streamController.add(TalkerData('Test ${level.name}', logLevel: level));
      }

      await expectLater(
        talkerLogger.logStream,
        emitsInOrder([
          predicate<domain_logs.LogEntry>((entry) => entry.level == domain_logs.LogLevel.debug),
          predicate<domain_logs.LogEntry>((entry) => entry.level == domain_logs.LogLevel.info),
          predicate<domain_logs.LogEntry>((entry) => entry.level == domain_logs.LogLevel.warning),
          predicate<domain_logs.LogEntry>((entry) => entry.level == domain_logs.LogLevel.error),
          predicate<domain_logs.LogEntry>((entry) => entry.level == domain_logs.LogLevel.error),
          predicate<domain_logs.LogEntry>((entry) => entry.level == domain_logs.LogLevel.verbose),
        ]),
      );

      verify(mockPersistenceManager.writeLog(any)).called(6);
    });

    test('logStream correctly transforms and persists multiple logs', () async {
      final logs = [
        TalkerData('Debug log', logLevel: LogLevel.debug),
        TalkerData('Info log', logLevel: LogLevel.info),
        TalkerData('Warning log', logLevel: LogLevel.warning),
      ];

      for (var log in logs) {
        streamController.add(log);
      }

      await expectLater(
        talkerLogger.logStream,
        emitsInOrder([
          predicate<domain_logs.LogEntry>((entry) => entry.level == domain_logs.LogLevel.debug && entry.message == 'Debug log'),
          predicate<domain_logs.LogEntry>((entry) => entry.level == domain_logs.LogLevel.info && entry.message == 'Info log'),
          predicate<domain_logs.LogEntry>((entry) => entry.level == domain_logs.LogLevel.warning && entry.message == 'Warning log'),
        ]),
      );

      verify(mockPersistenceManager.writeLog(any)).called(3);
    });

    test('dispose cancels subscription and closes stream', () async {
      final logStream = talkerLogger.logStream;

      talkerLogger.dispose();

      expect(logStream, emitsDone);
    });

    test('debug method calls Talker.debug', () {
      talkerLogger.debug('Debug message');
      verify(mockTalker.debug('Debug message')).called(1);
    });

    test('info method calls Talker.info', () {
      talkerLogger.info('Info message');
      verify(mockTalker.info('Info message')).called(1);
    });

    test('warning method calls Talker.warning', () {
      talkerLogger.warning('Warning message');
      verify(mockTalker.warning('Warning message')).called(1);
    });

    test('error method calls Talker.error', () {
      final error = Exception('Test error');
      final stackTrace = StackTrace.current;
      talkerLogger.error('Error message', error, stackTrace);
      verify(mockTalker.error('Error message', error, stackTrace)).called(1);
    });

    test('getLogsByPage calls LogPersistenceManager.readLogsByPage', () async {
      const page = 0;
      const pageSize = 10;
      final mockLogs = List.generate(
        pageSize,
        (index) => domain_logs.LogEntry(
          level: domain_logs.LogLevel.info,
          message: 'Log $index',
          timestamp: DateTime.now(),
        ),
      );

      when(mockPersistenceManager.readLogsByPage(page, pageSize))
          .thenAnswer((_) async => mockLogs);

      final result = await talkerLogger.getLogsByPage(page, pageSize);

      verify(mockPersistenceManager.readLogsByPage(page, pageSize)).called(1);
      expect(result, equals(mockLogs));
    });

    test('getLogsByPage returns empty list when no logs are available', () async {
      const page = 0;
      const pageSize = 10;

      when(mockPersistenceManager.readLogsByPage(page, pageSize))
          .thenAnswer((_) async => []);

      final result = await talkerLogger.getLogsByPage(page, pageSize);

      verify(mockPersistenceManager.readLogsByPage(page, pageSize)).called(1);
      expect(result, isEmpty);
    });

    test('getLogsByPage handles different page sizes', () async {
      const page = 1;
      const pageSize = 5;
      final mockLogs = List.generate(
        pageSize,
        (index) => domain_logs.LogEntry(
          level: domain_logs.LogLevel.info,
          message: 'Log ${index + pageSize}',
          timestamp: DateTime.now(),
        ),
      );

      when(mockPersistenceManager.readLogsByPage(page, pageSize))
          .thenAnswer((_) async => mockLogs);

      final result = await talkerLogger.getLogsByPage(page, pageSize);

      verify(mockPersistenceManager.readLogsByPage(page, pageSize)).called(1);
      expect(result.length, equals(pageSize));
      expect(result.first.message, equals('Log 5'));
      expect(result.last.message, equals('Log 9'));
    });

  });
}
