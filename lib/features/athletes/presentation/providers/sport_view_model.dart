import 'package:domain/features/athletes/entities/sport.dart';
import 'package:domain/features/athletes/repositories/sports.dart';
import 'package:domain/features/athletes/value_objects/sport_filter_criteria.dart';
import 'package:domain/features/shared/utilities/result.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:coach_app/features/athletes/presentation/models/sport_view.dart';
import 'package:coach_app/features/athletes/presentation/providers/sports_provider.dart';

/// Manages state and logic for the sports list, handling pagination.
class SportViewModel extends StateNotifier<AsyncValue<List<SportView>>> {
  final Sports _sports;

  /// Creates a new instance of SportsViewModel
  ///
  /// [_sports] The Sports use case for sports operations
  SportViewModel(this._sports) : super(const AsyncValue.loading()) {
    fetchSports();
  }

  Future<void> fetchSports({SportFilterCriteria? filterCriteria}) async {
    state = const AsyncValue.loading();
    final result = await _sports.getAllSports(filterCriteria: filterCriteria);

    if (result.isSuccess) {
      state = AsyncValue.data(result.value!.map(SportView.fromDomain).toList());
    } else {
      state = AsyncValue.error(result.error!, StackTrace.current);
    }
  }

  /// Adds a new sport
  Future<Result<Sport>> addSport(Sport sport) {
    return _sports.createSport(sport);
  }

  /// Updates an existing sport
  Future<Result<Sport>> updateSport(Sport sport) {
    return _sports.updateSport(sport);
  }

  /// Retrieves a sport by its ID
  Future<Result<Sport>> getSportById(String id) {
    return _sports.getSportById(id);
  }

  /// Retrieves sports by their IDs
  Future<Result<List<Sport>>> getSportsByIds(List<String> ids) {
    return _sports.getSportsByIds(ids);
  }
}

/// Provider for SportsViewModel
final sportViewModelProvider = AutoDisposeStateNotifierProvider<SportViewModel,
    AsyncValue<List<SportView>>>((ref) {
  final sports = ref.watch(sportsProvider);
  return SportViewModel(sports);
});
