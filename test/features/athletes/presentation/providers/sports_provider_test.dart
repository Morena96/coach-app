import 'package:domain/features/athletes/data/sports_service.dart';
import 'package:domain/features/logging/repositories/logger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:riverpod/riverpod.dart';

import 'package:coach_app/features/athletes/infrastructure/repositories/sports_impl.dart';
import 'package:coach_app/features/athletes/presentation/providers/sports_provider.dart';
import 'package:coach_app/features/athletes/presentation/providers/sports_service_provider.dart';
import 'package:coach_app/shared/providers/logger_provider.dart';

import '../../../../mocks.mocks.dart';

@GenerateMocks([SportsService, LoggerRepository])
void main() {
  group('sportsProvider', () {
    test('should create SportsImpl instance', () {
      final container = ProviderContainer(
        overrides: [
          sportsServiceProvider.overrideWithValue(MockSportsService()),
          loggerProvider.overrideWithValue(MockLoggerRepository()),
        ],
      );

      final sports = container.read(sportsProvider);

      expect(sports, isA<SportsImpl>());
    });
  });
}
