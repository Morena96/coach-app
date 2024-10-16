import 'package:application/athletes/use_cases/get_athlete_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:coach_app/features/athletes/presentation/models/athlete_view.dart';

/// ViewModel for managing the state of the AthleteViewPage.
class AthleteViewModel extends StateNotifier<AsyncValue<AthleteView>> {
  final GetAthleteByIdUseCase _getAthleteByIdUseCase;

  AthleteViewModel(this._getAthleteByIdUseCase)
      : super(const AsyncValue.loading());

  /// Fetches the athlete data by ID.
  Future<void> fetchAthlete(String athleteId) async {
    state = const AsyncValue.loading();
    final result = await _getAthleteByIdUseCase.execute(athleteId);
    if (result.isSuccess) {
      state = AsyncValue.data(AthleteView.fromDomain(result.value!));
    } else {
      state = AsyncValue.error(
        result.error ?? 'Unknown error',
        StackTrace.current,
      );
    }
  }
}
