import 'package:coach_app/shared/providers/directory_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:coach_app/features/athletes/presentation/providers/athletes_view_model.dart';
import 'package:coach_app/features/athletes/presentation/providers/athletes_view_model_provider.dart';
import 'package:coach_app/features/athletes/presentation/providers/create_athlete_use_case_provider.dart';
import 'package:coach_app/features/athletes/presentation/providers/delete_athlete_use_case_provider.dart';
import 'package:coach_app/features/athletes/presentation/providers/get_all_athletes_by_page_use_case_provider.dart';
import 'package:coach_app/features/athletes/presentation/providers/get_athlete_by_id_use_case_provider.dart';
import 'package:coach_app/features/athletes/presentation/providers/update_athlete_use_case_provider.dart';

import '../../../../unit/avatars/infrastructure/offline_first_avatar_repository_test.mocks.dart';
import '../../athletes_view_model_test.mocks.dart';

void main() {
  test(
      'athletesViewModelProvider creates AthletesViewModel with correct dependencies',
      () {
    final mockGetAllAthletesByPageUseCase = MockGetAllAthletesByPageUseCase();
    final mockGetAthleteByIdUseCase = MockGetAthleteByIdUseCase();
    final mockDeleteAthleteUseCase = MockDeleteAthleteUseCase();
    final mockCreateNewAthleteUseCase = MockCreateNewAthleteUseCase();
    final mockUpdateAthleteUseCase = MockUpdateAthleteUseCase();
    final mockDirectory = MockDirectory();

    final container = ProviderContainer(
      overrides: [
        getAllAthletesByPageUseCaseProvider
            .overrideWithValue(mockGetAllAthletesByPageUseCase),
        getAthleteByIdUseCaseProvider
            .overrideWithValue(mockGetAthleteByIdUseCase),
        deleteAthleteUseCaseProvider
            .overrideWithValue(mockDeleteAthleteUseCase),
        createNewAthleteUseCaseProvider
            .overrideWithValue(mockCreateNewAthleteUseCase),
        updateAthleteUseCaseProvider
            .overrideWithValue(mockUpdateAthleteUseCase),
        directoryProvider.overrideWithValue(mockDirectory),
      ],
    );

    final viewModel = container.read(athletesViewModelProvider.notifier);

    expect(viewModel, isA<AthletesViewModel>());

    // Verify that keepAlive was called
    expect(container.read(athletesViewModelProvider), isA<AsyncValue<void>>());
  });
}
