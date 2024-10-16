import 'package:application/athletes/use_cases/create_new_athlete_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:coach_app/features/athletes/presentation/providers/athlete_validation_service_provider.dart';
import 'package:coach_app/features/athletes/presentation/providers/athletes_provider.dart';
import 'package:coach_app/features/athletes/presentation/providers/create_athlete_use_case_provider.dart';
import 'package:coach_app/features/athletes/presentation/providers/sports_provider.dart';
import 'package:coach_app/features/avatars/infrastructure/provider/avatar_repository_provider.dart';

import '../../../../mocks.mocks.dart';

void main() {
  test(
      'createNewAthleteUseCaseProvider creates CreateNewAthleteUseCase with correct dependencies',
      () {
    final mockAthletes = MockAthletes();
    final mockSports = MockSports();
    final mockValidationService = MockAthleteValidationService();
    final mockAvatarRepository = MockAvatarRepository();

    final container = ProviderContainer(
      overrides: [
        athletesProvider.overrideWithValue(mockAthletes),
        sportsProvider.overrideWithValue(mockSports),
        athleteValidationServiceProvider
            .overrideWithValue(mockValidationService),
        avatarRepositoryProvider.overrideWithValue(mockAvatarRepository),
      ],
    );

    final useCase = container.read(createNewAthleteUseCaseProvider);

    expect(useCase, isA<CreateNewAthleteUseCase>());
  });
}
