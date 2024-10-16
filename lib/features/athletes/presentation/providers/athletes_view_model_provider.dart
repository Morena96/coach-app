import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:coach_app/features/athletes/presentation/providers/athletes_view_model.dart';
import 'package:coach_app/features/athletes/presentation/providers/create_athlete_use_case_provider.dart';
import 'package:coach_app/features/athletes/presentation/providers/delete_athlete_use_case_provider.dart';
import 'package:coach_app/features/athletes/presentation/providers/get_all_athletes_by_page_use_case_provider.dart';
import 'package:coach_app/features/athletes/presentation/providers/get_athlete_by_id_use_case_provider.dart';
import 'package:coach_app/features/athletes/presentation/providers/restore_athlete_use_case_provider.dart';
import 'package:coach_app/features/athletes/presentation/providers/update_athlete_use_case_provider.dart';

final athletesViewModelProvider =
    StateNotifierProvider.autoDispose<AthletesViewModel, AsyncValue<void>>(
        (ref) {
  ref.keepAlive();

  final getAllAthletesByPageUseCase =
      ref.watch(getAllAthletesByPageUseCaseProvider);
  final getAthleteByIdUseCase = ref.watch(getAthleteByIdUseCaseProvider);
  final deleteAthleteUseCase = ref.watch(deleteAthleteUseCaseProvider);
  final restoreAthleteUseCase = ref.watch(restoreAthleteUseCaseProvider);
  final createNewAthleteUseCase = ref.watch(createNewAthleteUseCaseProvider);
  final updateAthleteUseCase = ref.watch(updateAthleteUseCaseProvider);

  return AthletesViewModel(
    getAllAthletesByPageUseCase,
    deleteAthleteUseCase,
    restoreAthleteUseCase,
    createNewAthleteUseCase,
    getAthleteByIdUseCase,
    updateAthleteUseCase,
  );
});
