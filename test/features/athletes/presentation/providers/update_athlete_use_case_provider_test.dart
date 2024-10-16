import 'package:application/athletes/use_cases/update_athlete_use_case.dart';
import 'package:coach_app/features/athletes/presentation/providers/athlete_validation_service_provider.dart';
import 'package:coach_app/features/athletes/presentation/providers/athletes_provider.dart';
import 'package:coach_app/features/athletes/presentation/providers/update_athlete_use_case_provider.dart';
import 'package:coach_app/shared/providers/directory_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../mocks.mocks.dart';
// Import your necessary files here

void main() {
  test(
      'updateAthleteUseCaseProvider creates UpdateAthleteUseCase with correct dependencies',
      () {
    final mockAthletes = MockAthletes();
    final mockValidationService = MockAthleteValidationService();
    final mockDirectory = MockDirectory();

    final container = ProviderContainer(
      overrides: [
        athletesProvider.overrideWithValue(mockAthletes),
        athleteValidationServiceProvider
            .overrideWithValue(mockValidationService),
        directoryProvider.overrideWithValue(mockDirectory),
      ],
    );

    final useCase = container.read(updateAthleteUseCaseProvider);

    expect(useCase, isA<UpdateAthleteUseCase>());
  });
}
