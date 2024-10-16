import 'package:application/athletes/use_cases/get_athlete_use_case.dart';
import 'package:coach_app/features/athletes/presentation/providers/athletes_provider.dart';
import 'package:coach_app/features/athletes/presentation/providers/get_athlete_by_id_use_case_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../mocks.mocks.dart';
// Import your necessary files here

void main() {
  test(
      'getAthleteByIdUseCaseProvider creates GetAthleteByIdUseCase with correct dependency',
      () {
    final mockAthletes = MockAthletes();

    final container = ProviderContainer(
      overrides: [
        athletesProvider.overrideWithValue(mockAthletes),
      ],
    );

    final useCase = container.read(getAthleteByIdUseCaseProvider);

    expect(useCase, isA<GetAthleteByIdUseCase>());
  });
}
