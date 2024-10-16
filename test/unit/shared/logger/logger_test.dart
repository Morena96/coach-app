import 'package:domain/features/logging/repositories/logger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockLogger extends Mock implements LoggerRepository {}

void main() {
  group('Logger Interface', () {
    late MockLogger mockLogger;

    setUp(() {
      mockLogger = MockLogger();
    });

    test('debug method is called', () {
      mockLogger.debug('Debug message');
      verify(mockLogger.debug('Debug message')).called(1);
    });

    test('info method is called', () {
      mockLogger.info('Info message');
      verify(mockLogger.info('Info message')).called(1);
    });

    test('warning method is called', () {
      mockLogger.warning('Warning message');
      verify(mockLogger.warning('Warning message')).called(1);
    });

    test('error method is called', () {
      final error = Exception('Test error');
      final stackTrace = StackTrace.current;
      mockLogger.error('Error message', error, stackTrace);
      verify(mockLogger.error('Error message', error, stackTrace)).called(1);
    });
  });
}
