import 'package:application/athletes/use_cases/get_all_sports_by_page_use_case.dart';
import 'package:domain/features/athletes/entities/sport.dart';
import 'package:domain/features/athletes/value_objects/sport_filter_criteria.dart';
import 'package:domain/features/shared/utilities/result.dart';
import 'package:domain/features/shared/value_objects/filter_criteria.dart';
import 'package:domain/features/shared/value_objects/sort_criteria.dart';

import 'package:coach_app/features/athletes/presentation/models/sport_view.dart';
import 'package:coach_app/shared/view_models/paginated_view_model.dart';

/// Manages state and logic for the sports list, handling pagination.
class SportsViewModel extends PaginatedViewModel<SportView, Sport> {
  final GetAllSportsByPageUseCase _getAllSportsByPageUseCase;

  SportFilterCriteria _currentFilter;

  SportsViewModel(
    this._getAllSportsByPageUseCase, {
    String initialNameFilter = '',
    List<String> initialSportsFilter = const [],
  })  : _currentFilter = SportFilterCriteria(name: initialNameFilter),
        super() {
    applyCriteria(filterCriteria: _currentFilter);
  }

  String? get currentNameFilter => _currentFilter.name;
  int? r;

  @override
  Future<Result<List<Sport>>> fetchItems(
    int pageKey,
    int pageSize, {
    FilterCriteria? filterCriteria,
    SortCriteria? sortCriteria,
  }) async {
    final result = await _getAllSportsByPageUseCase.execute(
      pageKey,
      pageSize,
      filterCriteria: filterCriteria as SportFilterCriteria?,
    );

    return result;
  }

  /// Updates the name filter and applies the updated criteria.
  void updateNameFilter(String name) {
    if (name == (_currentFilter.name ?? '')) return;
    _currentFilter = _currentFilter.copyWith(name: name);
    applyCriteria(filterCriteria: _currentFilter);
  }

  @override
  SportView convertItem(Sport item) {
    return SportView.fromDomain(item);
  }

  @override
  Future<Result<void>> deleteItemFromService(SportView item) {
    throw UnimplementedError();
  }
}
