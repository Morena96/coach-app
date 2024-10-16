import 'package:application/athletes/use_cases/delete_athlete_use_case.dart';
import 'package:coach_app/features/athletes/presentation/providers/athletes_provider.dart';
import 'package:coach_app/features/athletes/presentation/providers/delete_athlete_use_case_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Import your necessary files here

import '../../../../mocks.mocks.dart';

@GenerateMocks([DeleteAthleteUseCase])
void main() {
  test(
      'deleteAthleteUseCaseProvider creates DeleteAthleteUseCase with correct dependency',
      () {
    final mockAthletes = MockAthletes();

    final container = ProviderContainer(
      overrides: [
        athletesProvider.overrideWithValue(mockAthletes),
      ],
    );

    final useCase = container.read(deleteAthleteUseCaseProvider);

    expect(useCase, isA<DeleteAthleteUseCase>());
  });
}
