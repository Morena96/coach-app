import 'package:application/logging/use_cases/get_all_logs_by_page_use_case.dart';
import 'package:domain/features/logging/entities/log_entry.dart';
import 'package:domain/features/logging/repositories/logger.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([LoggerRepository])
import 'get_all_logs_by_page_use_case_test.mocks.dart';

void main() {
  late GetAllLogsByPageUseCase useCase;
  late MockLoggerRepository mockLogger;

  setUp(() {
    mockLogger = MockLoggerRepository();
    useCase = GetAllLogsByPageUseCase(mockLogger);
  });

  group('GetAllLogsByPageUseCase', () {
    test('should return logs from logger repository', () async {
      // Arrange
      final expectedLogs = [
        LogEntry(level: LogLevel.info, message: 'Test log 1'),
        LogEntry(level: LogLevel.warning, message: 'Test log 2'),
      ];
      when(mockLogger.getLogsByPage(any, any)).thenAnswer((_) async => expectedLogs);

      // Act
      final result = await useCase.execute(0, 10);

      // Assert
      expect(result, equals(expectedLogs));
      verify(mockLogger.getLogsByPage(0, 10)).called(1);
    });

    test('should return empty list when no logs are available', () async {
      // Arrange
      when(mockLogger.getLogsByPage(any, any)).thenAnswer((_) async => []);

      // Act
      final result = await useCase.execute(0, 10);

      // Assert
      expect(result, isEmpty);
      verify(mockLogger.getLogsByPage(0, 10)).called(1);
    });

    test('should pass correct page and pageSize to logger repository', () async {
      // Arrange
      when(mockLogger.getLogsByPage(any, any)).thenAnswer((_) async => []);

      // Act
      await useCase.execute(2, 15);

      // Assert
      verify(mockLogger.getLogsByPage(2, 15)).called(1);
    });

    test('should throw when logger repository throws', () async {
      // Arrange
      when(mockLogger.getLogsByPage(any, any)).thenThrow(Exception('Test exception'));

      // Act & Assert
      expect(() => useCase.execute(0, 10), throwsException);
    });
  });
}
