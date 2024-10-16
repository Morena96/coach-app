import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:coach_app/features/athletes/presentation/models/athlete_view.dart';
import 'package:coach_app/features/athletes/presentation/providers/athlete_view_model.dart';
import 'package:coach_app/features/athletes/presentation/providers/get_athlete_by_id_use_case_provider.dart';

final athleteViewModelProvider = StateNotifierProvider.autoDispose
    .family<AthleteViewModel, AsyncValue<AthleteView>, String>(
  (ref, athleteId) {
    final getAthleteByIdUseCase = ref.watch(getAthleteByIdUseCaseProvider);
    return AthleteViewModel(getAthleteByIdUseCase)..fetchAthlete(athleteId);
  },
);
