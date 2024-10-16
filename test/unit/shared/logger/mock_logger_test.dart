import 'package:coach_app/shared/services/logging/mock_logger.dart';
import 'package:domain/features/logging/entities/log_entry.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MockLogger', () {
    late MockLogger mockLogger;

    setUp(() {
      mockLogger = MockLogger();
    });

    test('debug adds a debug message to logs', () {
      mockLogger.debug('Debug message');
      expect(mockLogger.logs.last.level, equals(LogLevel.debug));
      expect(mockLogger.logs.last.message, equals('Debug message'));
    });

    test('info adds an info message to logs', () {
      mockLogger.info('Info message');
      expect(mockLogger.logs.last.level, equals(LogLevel.info));
      expect(mockLogger.logs.last.message, equals('Info message'));
    });

    test('warning adds a warning message to logs', () {
      mockLogger.warning('Warning message');
      expect(mockLogger.logs.last.level, equals(LogLevel.warning));
      expect(mockLogger.logs.last.message, equals('Warning message'));
    });

    test('error adds an error message to logs', () {
      final error = Exception('Test error');
      final stackTrace = StackTrace.current;
      mockLogger.error('Error message', error, stackTrace);
      expect(mockLogger.logs.last.level, equals(LogLevel.error));
      expect(mockLogger.logs.last.message, equals('Error message'));
      expect(mockLogger.logs.last.error, equals(error));
      expect(mockLogger.logs.last.stackTrace, equals(stackTrace));
    });

    test('logs are in correct order', () {
      mockLogger.debug('1');
      mockLogger.info('2');
      mockLogger.warning('3');
      mockLogger.error('4');
      expect(mockLogger.logs.map((log) => log.message), equals(['1', '2', '3', '4']));
      expect(mockLogger.logs.map((log) => log.level), 
          equals([LogLevel.debug, LogLevel.info, LogLevel.warning, LogLevel.error]));
    });

    test('logStream correctly returns Stream<LogEntry>', () async {
      final logStream = mockLogger.logStream;

      // Emitting sample LogEntry
      mockLogger.debug('Test log message');
      
      final logEntry = await logStream.first;
      expect(logEntry.level, equals(LogLevel.debug));
      expect(logEntry.message, equals('Test log message'));
    });
  });
}
