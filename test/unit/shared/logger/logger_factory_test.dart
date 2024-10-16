import 'package:coach_app/shared/services/logging/logger_factory.dart';
import 'package:coach_app/shared/services/logging/mock_logger.dart';
import 'package:coach_app/shared/services/logging/talker_logger.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LoggerFactory', () {
    test('creates TalkerLogger for LoggerType.talker', () {
      final logger = LoggerFactory.createLogger(LoggerType.talker);
      expect(logger, isA<TalkerLogger>());
    });

    test('creates MockLogger for LoggerType.mock', () {
      final logger = LoggerFactory.createLogger(LoggerType.mock);
      expect(logger, isA<MockLogger>());
    });

    test('throws ArgumentError for unknown LoggerType', () {
      expect(() => LoggerFactory.createLogger(LoggerType.unknown),
          throwsArgumentError);
    });
  });
}
