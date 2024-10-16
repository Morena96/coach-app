import 'package:application/athletes/use_cases/get_all_athletes_by_page_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:coach_app/features/athletes/presentation/providers/athletes_provider.dart';
import 'package:coach_app/features/athletes/presentation/providers/get_all_athletes_by_page_use_case_provider.dart';

import '../../../../mocks.mocks.dart';

void main() {
  test(
      'getAllAthletesByPageUseCaseProvider creates GetAllAthletesByPageUseCase with correct dependency',
      () {
    final mockAthletes = MockAthletes();

    final container = ProviderContainer(
      overrides: [
        athletesProvider.overrideWithValue(mockAthletes),
      ],
    );

    final useCase = container.read(getAllAthletesByPageUseCaseProvider);

    expect(useCase, isA<GetAllAthletesByPageUseCase>());
  });
}
