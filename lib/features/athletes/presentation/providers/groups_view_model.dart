import 'package:application/athletes/use_cases/create_group_use_case.dart';
import 'package:application/athletes/use_cases/delete_group_use_case.dart';
import 'package:application/athletes/use_cases/get_all_groups_by_page_use_case.dart';
import 'package:application/athletes/use_cases/get_group_use_case.dart';
import 'package:application/athletes/use_cases/restore_group_use_case.dart';
import 'package:application/athletes/use_cases/update_group_use_case.dart';
import 'package:domain/features/athletes/entities/group.dart';
import 'package:domain/features/athletes/entities/sport.dart';
import 'package:domain/features/athletes/value_objects/groups_filter_criteria.dart';
import 'package:domain/features/avatars/entities/image_data.dart';
import 'package:domain/features/shared/utilities/result.dart';
import 'package:domain/features/shared/value_objects/filter_criteria.dart';
import 'package:domain/features/shared/value_objects/sort_criteria.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:coach_app/core/widgets/multi_filter.dart';
import 'package:coach_app/features/athletes/presentation/models/group_view.dart';
import 'package:coach_app/features/athletes/presentation/models/sport_view.dart';
import 'package:coach_app/shared/view_models/paginated_view_model.dart';

/// ViewModel for managing and paginating groups with filtering capabilities.
class GroupsViewModel extends PaginatedViewModel<GroupView, Group> {
  final GetGroupByIdUseCase _getGroupByIdUseCase;
  final UpdateGroupUseCase _updateGroupUseCase;
  final DeleteGroupUseCase _deleteGroupUseCase;
  final RestoreGroupUseCase _restoreGroupUseCase;
  final CreateGroupUseCase _createGroupUseCase;
  final GetAllGroupsByPageUseCase _getAllGroupsByPageUseCase;

  GroupsFilterCriteria _currentFilter;

  /// Currently applied sports filters.
  List<FilterOption>? currentSports;

  /// Constructs a GroupsViewModel with necessary use cases and initial filters.
  GroupsViewModel(
    this._getAllGroupsByPageUseCase,
    this._deleteGroupUseCase,
    this._restoreGroupUseCase,
    this._getGroupByIdUseCase,
    this._createGroupUseCase,
    this._updateGroupUseCase, {
    String initialNameFilter = '',
    List<String> initialSportsFilter = const [],
  })  : _currentFilter = GroupsFilterCriteria(
            name: initialNameFilter, sports: initialSportsFilter),
        super() {
    applyCriteria(filterCriteria: _currentFilter);
  }

  /// Current name filter.
  String? get currentNameFilter => _currentFilter.name;

  /// Current sports filter.
  List<String>? get currentSportsFilter => _currentFilter.sports;

  /// Fetches a page of group items from the data source.
  @override
  Future<Result<List<Group>>> fetchItems(
    int pageKey,
    int pageSize, {
    FilterCriteria? filterCriteria,
    SortCriteria? sortCriteria,
  }) {
    return _getAllGroupsByPageUseCase.execute(pageKey, pageSize,
        filterCriteria: filterCriteria as GroupsFilterCriteria?);
  }

  /// Updates the name filter and applies the updated criteria.
  void updateNameFilter(String name) {
    _currentFilter = _currentFilter.copyWith(name: name);
    updateHasActiveFilters(hasActiveFilters: hasActiveFilters);
    applyCriteria(filterCriteria: _currentFilter);
  }

  /// Updates the sports filter and applies the updated criteria.
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

  /// Clears all applied filters.
  void clearAllFilters() {
    _currentFilter = GroupsFilterCriteria();
    updateHasActiveFilters(hasActiveFilters: hasActiveFilters);
    applyCriteria(filterCriteria: _currentFilter);
    updateFilters(sports: []);
    refresh();
  }

  /// Converts a domain Group to a GroupView for presentation.
  @override
  GroupView convertItem(Group item) => GroupView.fromDomain(item);

  /// Deletes a group from the service.
  @override
  Future<Result<void>> deleteItemFromService(GroupView item) {
    return _deleteGroupUseCase.execute(item.id);
  }

  /// Adds a new group.
  Future<Result<Group>> addGroup(
    Map<String, dynamic> athlete,
    String name,
    String? description,
    SportView? sport,
    ImageData? avatarImage,
  ) {
    return _createGroupUseCase.execute(
      athlete,
      name,
      description,
      sport != null ? Sport(id: sport.id, name: sport.name) : null,
      avatarImage: avatarImage,
    );
  }

  /// Updates an existing group.
  Future<Result<void>> updateGroup(
      GroupView group, Map<String, dynamic> groupData, ImageData? avatar) {
    return _updateGroupUseCase.execute(group.toDomain(), groupData, avatar);
  }

  /// Retrieves a group by its ID.
  Future<Result<Group>> getGroupById(String id) {
    return _getGroupByIdUseCase.execute(id);
  }

  /// Restores a previously deleted group.
  Future<bool> restoreGroup(GroupView athlete) async {
    final result = await _restoreGroupUseCase.execute(athlete.id);
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

  /// Checks if any filters are currently applied.
  bool get hasActiveFilters =>
      _currentFilter.name?.isNotEmpty == true ||
      (_currentFilter.sports ?? []).isNotEmpty;
}
