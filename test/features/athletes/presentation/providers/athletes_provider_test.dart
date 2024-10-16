import 'package:coach_app/features/athletes/presentation/providers/members_service_provider.dart';
import 'package:domain/features/athletes/data/athletes_service.dart';
import 'package:domain/features/athletes/data/members_service.dart';
import 'package:domain/features/logging/repositories/logger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:riverpod/riverpod.dart';

import 'package:coach_app/features/athletes/infrastructure/repositories/athletes_impl.dart';
import 'package:coach_app/features/athletes/presentation/providers/athletes_provider.dart';
import 'package:coach_app/features/athletes/presentation/providers/athletes_service_provider.dart';
import 'package:coach_app/shared/providers/logger_provider.dart';

// Generate mocks
@GenerateMocks([AthletesService, LoggerRepository, MembersService])
import 'athletes_provider_test.mocks.dart';

void main() {
  test('athletesProvider creates AthletesImpl with correct dependencies', () {
    final mockAthletesService = MockAthletesService();
    final mockLogger = MockLoggerRepository();
    final mockMembersService = MockMembersService();

    final container = ProviderContainer(
      overrides: [
        athletesServiceProvider.overrideWithValue(mockAthletesService),
        loggerProvider.overrideWithValue(mockLogger),
        membersServiceProvider.overrideWithValue(mockMembersService),
      ],
    );

    final athletes = container.read(athletesProvider);

    expect(athletes, isA<AthletesImpl>());
  });
}
