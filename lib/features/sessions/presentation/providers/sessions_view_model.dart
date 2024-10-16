import 'package:application/sessions/use_cases/delete_session_use_case.dart';
import 'package:application/sessions/use_cases/get_all_sessions_by_page_use_case.dart';
import 'package:domain/features/sessions/entities/session.dart';
import 'package:domain/features/sessions/value_objects/sessions_filter_criteria.dart';
import 'package:domain/features/sessions/value_objects/sessions_sort_criteria.dart';
import 'package:domain/features/shared/utilities/result.dart';
import 'package:domain/features/shared/value_objects/filter_criteria.dart';
import 'package:domain/features/shared/value_objects/sort_criteria.dart';
import 'package:domain/features/shared/value_objects/sort_order.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';

import 'package:coach_app/core/widgets/multi_filter.dart';
import 'package:coach_app/features/sessions/presentation/models/session_view.dart';
import 'package:coach_app/shared/view_models/paginated_view_model.dart';

/// ViewModel for managing and filtering sessions in a paginated list.
///
/// This class extends [PaginatedViewModel] to handle pagination, filtering,
/// and sorting of sessions. It interacts with use cases to fetch and delete
/// sessions, and manages the current filter and sort criteria.
class SessionsViewModel extends PaginatedViewModel<SessionView, Session> {
  final GetAllSessionsByPageUseCase _getAllSessionsByPageUseCase;
  final DeleteSessionUseCase _deleteSessionUseCase;
  SessionsFilterCriteria _currentFilter;
  SessionsSortCriteria _currentSort;

  List<FilterOption>? currentSports;
  List<FilterOption>? currentAthletes;
  List<FilterOption>? currentGroups;

  SessionsViewModel(
    this._getAllSessionsByPageUseCase,
    this._deleteSessionUseCase, {
    String initialNameFilter = '',
    String? initialGroupId,
    List<String> initialSportsFilter = const [],
  })  : _currentFilter = SessionsFilterCriteria(
          title: initialNameFilter,
          groupId: initialGroupId,
          sports: initialSportsFilter,
        ),
        _currentSort =
            SessionsSortCriteria(field: 'date', order: SortOrder.ascending),
        super() {
    applyCriteria(filterCriteria: _currentFilter, sortCriteria: _currentSort);
  }

  /// The current title filter applied to the sessions.
  String? get currentTitleFilter => _currentFilter.title;

  DateRange? get currentDateRange => _currentFilter.startTimeFrom != null &&
          _currentFilter.startTimeTo != null
      ? DateRange(_currentFilter.startTimeFrom!, _currentFilter.startTimeTo!)
      : null;

  /// The current sort criteria applied to the sessions.
  SessionsSortCriteria get currentSort => _currentSort;

  /// Checks if any filters are currently applied to the sessions.
  bool get hasActiveFilters =>
      _currentFilter.title?.isNotEmpty == true ||
      (_currentFilter.sports ?? []).isNotEmpty ||
      (_currentFilter.assignedGroups).isNotEmpty ||
      (_currentFilter.selectedAthletes).isNotEmpty ||
      _currentFilter.startTimeFrom != null ||
      _currentFilter.startTimeTo != null;

  /// Fetches a page of sessions based on the given criteria.
  ///
  /// This method is called by the pagination controller to load
  /// new pages of data.
  @override
  Future<Result<List<Session>>> fetchItems(
    int pageKey,
    int pageSize, {
    FilterCriteria? filterCriteria,
    SortCriteria? sortCriteria,
  }) async {
    final result = await _getAllSessionsByPageUseCase.execute(
      pageKey,
      pageSize,
      filterCriteria: filterCriteria as SessionsFilterCriteria?,
      sortCriteria: sortCriteria as SessionsSortCriteria?,
    );

    return result;
  }

  /// Updates the name filter and applies the updated criteria.
  void updateNameFilter(String name) {
    if (name == (_currentFilter.title ?? '')) return;
    _currentFilter = _currentFilter.copyWith(title: name);
    updateHasActiveFilters(hasActiveFilters: hasActiveFilters);
    applyCriteria(filterCriteria: _currentFilter);
  }

  /// Updates the sports, athletes and groups filter and applies the updated criteria.
  void updateFilters({
    List<FilterOption>? sports,
    List<FilterOption>? athletes,
    List<FilterOption>? groups,
  }) {
    currentSports = sports;
    currentGroups = groups;
    currentAthletes = athletes;

    _currentFilter = _currentFilter.copyWith(
      sports: sports?.map((e) => e.id).toList(),
      selectedAthletes: athletes?.map((e) => e.id).toList(),
      assignedGroups: groups?.map((e) => e.id).toList(),
    );
    updateHasActiveFilters(hasActiveFilters: hasActiveFilters);
    applyCriteria(filterCriteria: _currentFilter);
  }

  /// Updates date range and applies the updated criteria.
  void updateDateRange({
    DateTime? fromDate,
    DateTime? toDate,
  }) {
    _currentFilter = _currentFilter.copyWith(
      startTimeFrom: fromDate,
      startTimeTo: toDate,
      clearDates: fromDate == null && toDate == null,
    );
    updateHasActiveFilters(hasActiveFilters: hasActiveFilters);
    applyCriteria(filterCriteria: _currentFilter);
  }

  /// Clears all filters and resets the sort criteria.
  void clearAllFilters() {
    _currentSort = SessionsSortCriteria(field: '', order: SortOrder.ascending);
    applyCriteria(
        filterCriteria: SessionsFilterCriteria(), sortCriteria: _currentSort);
    updateNameFilter('');
    updateDateRange(fromDate: null, toDate: null);
    updateFilters(sports: [], athletes: [], groups: []);
    updateHasActiveFilters(hasActiveFilters: hasActiveFilters);
    refresh();
  }

  /// Updates the sort criteria for the specified field.
  ///
  /// If the field is already being sorted, it toggles the sort order.
  /// Otherwise, it sets a new sort field with ascending order.
  void updateSort(String field) {
    if (_currentSort.field == field) {
      _currentSort = _currentSort.copyWith(
        order: _currentSort.order == SortOrder.ascending
            ? SortOrder.descending
            : SortOrder.ascending,
      );
    } else {
      _currentSort =
          SessionsSortCriteria(field: field, order: SortOrder.ascending);
    }
    applyCriteria(filterCriteria: _currentFilter, sortCriteria: _currentSort);
    refresh();
  }

  /// Converts a domain [Session] object to a [SessionView] object.
  @override
  SessionView convertItem(Session item) {
    return SessionView.fromDomain(item);
  }

  /// Deletes a session from the service.
  @override
  Future<Result<void>> deleteItemFromService(SessionView item) {
    return _deleteSessionUseCase.execute(item.id);
  }
}
