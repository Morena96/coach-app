import 'package:application/athletes/use_cases/create_new_athlete_use_case.dart';
import 'package:application/athletes/use_cases/delete_athlete_use_case.dart';
import 'package:application/athletes/use_cases/get_all_athletes_by_page_use_case.dart';
import 'package:application/athletes/use_cases/get_athlete_use_case.dart';
import 'package:application/athletes/use_cases/restore_athlete_use_case.dart';
import 'package:application/athletes/use_cases/update_athlete_use_case.dart';
import 'package:coach_app/core/widgets/multi_filter.dart';

import 'package:domain/features/athletes/entities/athlete.dart';
import 'package:domain/features/athletes/value_objects/athlete_filter_criteria.dart';
import 'package:domain/features/athletes/value_objects/athlete_sort_criteria.dart';
import 'package:domain/features/avatars/entities/image_data.dart';
import 'package:domain/features/shared/utilities/result.dart';
import 'package:domain/features/shared/value_objects/filter_criteria.dart';
import 'package:domain/features/shared/value_objects/sort_criteria.dart';
import 'package:domain/features/shared/value_objects/sort_order.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:coach_app/features/athletes/presentation/models/athlete_view.dart';
import 'package:coach_app/shared/view_models/paginated_view_model.dart';

/// Manages state and logic for the athletes list, handling pagination.
class AthletesViewModel extends PaginatedViewModel<AthleteView, Athlete> {
  final GetAllAthletesByPageUseCase _getAllAthletesByPageUseCase;
  final GetAthleteByIdUseCase _getAthleteByIdUseCase;
  final DeleteAthleteUseCase _deleteAthleteUseCase;
  final RestoreAthleteUseCase _restoreAthleteUseCase;
  final CreateNewAthleteUseCase _createNewAthleteUseCase;
  final UpdateAthleteUseCase _updateAthleteUseCase;
  AthleteFilterCriteria _currentFilter;
  AthleteSortCriteria _currentSort;

  List<FilterOption>? currentSports;

  AthletesViewModel(
    this._getAllAthletesByPageUseCase,
    this._deleteAthleteUseCase,
    this._restoreAthleteUseCase,
    this._createNewAthleteUseCase,
    this._getAthleteByIdUseCase,
    this._updateAthleteUseCase, {
    String initialNameFilter = '',
    List<String> initialSportsFilter = const [],
  })  : _currentFilter = AthleteFilterCriteria(
            name: initialNameFilter,
            sports: initialSportsFilter,
            isArchived: false),
        _currentSort =
            AthleteSortCriteria(field: 'name', order: SortOrder.ascending),
        super() {
    applyCriteria(filterCriteria: _currentFilter, sortCriteria: _currentSort);
  }

  String? get currentNameFilter => _currentFilter.name;
  bool get currentArchivedFilter => _currentFilter.isArchived ?? false;
  List<String>? get currentSportsFilter => _currentFilter.sports;
  AthleteSortCriteria get currentSort => _currentSort;
  int? r;

  String? _currentGroupId;

  // Set the current group ID when selecting athletes for a specific group
  void setCurrentGroupId(String groupId) {
    _currentGroupId = groupId;
    refresh();
  }

  /// Checks if any filters are currently applied
  bool get hasActiveFilters =>
      _currentFilter.name?.isNotEmpty == true ||
      (_currentFilter.sports ?? []).isNotEmpty;

  @override
  Future<Result<List<Athlete>>> fetchItems(
    int pageKey,
    int pageSize, {
    FilterCriteria? filterCriteria,
    SortCriteria? sortCriteria,
  }) async {
    final result = await _getAllAthletesByPageUseCase.execute(
      pageKey,
      pageSize,
      filterCriteria: filterCriteria as AthleteFilterCriteria?,
      sortCriteria: sortCriteria as AthleteSortCriteria? ?? _currentSort,
    );

    if (result.isSuccess && _currentGroupId != null) {
      return Result.success((result.value ?? [])
          .where((athlete) => !athlete.groups.contains(_currentGroupId))
          .toList());
    }

    return result;
  }

  /// Updates the name filter and applies the updated criteria.
  void updateNameFilter(String name) {
    if (name == (_currentFilter.name ?? '')) return;

    _currentFilter = _currentFilter.copyWith(name: name);

    updateHasActiveFilters(hasActiveFilters: hasActiveFilters);

    applyCriteria(filterCriteria: _currentFilter);
  }

  /// Updates the sports, athletes and groups filter and applies the updated criteria.
  void updateFilters({
    List<FilterOption>? sports,
  }) {
    currentSports = sports;

    _currentFilter = _currentFilter.copyWith(
      sports: sports?.map((e) => e.id).toList(),
    );
    updateHasActiveFilters(hasActiveFilters: hasActiveFilters);
    applyCriteria(filterCriteria: _currentFilter);
  }

  /// Updates the sports filter and applies the updated criteria.
  void updateArchivedFilter({required bool isArchived}) {
    _currentFilter = _currentFilter.copyWith(isArchived: isArchived);
    applyCriteria(filterCriteria: _currentFilter);
  }

  void clearAllFilters() {
    _currentFilter =
        AthleteFilterCriteria(isArchived: _currentFilter.isArchived);
    _currentSort = AthleteSortCriteria(field: '', order: SortOrder.ascending);
    applyCriteria(filterCriteria: _currentFilter, sortCriteria: _currentSort);
    updateHasActiveFilters(hasActiveFilters: hasActiveFilters);
    updateFilters(sports: []);
    refresh();
  }

  void updateSort(String field) {
    if (_currentSort.field == field) {
      _currentSort = _currentSort.copyWith(
        order: _currentSort.order == SortOrder.ascending
            ? SortOrder.descending
            : SortOrder.ascending,
      );
    } else {
      _currentSort =
          AthleteSortCriteria(field: field, order: SortOrder.ascending);
    }
    applyCriteria(filterCriteria: _currentFilter, sortCriteria: _currentSort);
    refresh();
  }

  @override
  AthleteView convertItem(Athlete item) {
    return AthleteView.fromDomain(item);
  }

  @override
  Future<Result<void>> deleteItemFromService(AthleteView item) {
    return _deleteAthleteUseCase.execute(item.id);
  }

  Future<Result<AthleteView>> addAthlete(Map<String, dynamic> athlete,
      List<String> sportIds, ImageData? avatar) async {
    final result =
        await _createNewAthleteUseCase.execute(athlete, sportIds, avatar);
    if (result.isSuccess) {
      return Result.success(AthleteView.fromDomain(result.value!));
    } else {
      return Result.failure(result.error);
    }
  }

  Future<Result<void>> updateAthlete(
      Athlete athlete, Map<String, dynamic> athleteData, ImageData? avatar) {
    return _updateAthleteUseCase.execute(athlete, athleteData, avatar);
  }

  Future<Result<Athlete>> getAthleteById(String id) {
    return _getAthleteByIdUseCase.execute(id);
  }

  Future<bool> restoreAthlete(AthleteView athlete) async {
    final result = await _restoreAthleteUseCase.execute(athlete.id);
    if (result.isSuccess) {
      pagingController.itemList?.removeWhere((i) => i == athlete);
      pagingController.notifyListeners();
      state = const AsyncValue.data(null);
      return true;
    } else {
      state =
          AsyncValue.error(result.error ?? 'Unknown error', StackTrace.current);
      return false;
    }
  }
}
