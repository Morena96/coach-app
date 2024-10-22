import 'package:application/athletes/use_cases/batch_add_groups_to_member_use_case.dart';
import 'package:application/athletes/use_cases/get_all_groups_by_page_use_case.dart';
import 'package:domain/features/athletes/entities/group.dart';
import 'package:domain/features/athletes/entities/group_role.dart';
import 'package:domain/features/athletes/value_objects/groups_filter_criteria.dart';
import 'package:domain/features/shared/utilities/result.dart';
import 'package:domain/features/shared/value_objects/filter_criteria.dart';
import 'package:domain/features/shared/value_objects/sort_criteria.dart';

import 'package:coach_app/features/athletes/presentation/models/group_view.dart';
import 'package:coach_app/shared/view_models/paginated_view_model.dart';

/// Base ViewModel for athlete groups, containing common functionality.
abstract class BaseAthleteGroupsViewModel
    extends PaginatedViewModel<GroupView, Group> {
  final GetAllGroupsByPageUseCase _getAllGroupsByPageUseCase;
  final BatchAddGroupsToMemberUseCase _batchAddGroupsToMemberUseCase;
  final String athleteId;

  GroupsFilterCriteria _currentFilter;

  BaseAthleteGroupsViewModel(
    this._getAllGroupsByPageUseCase,
    this._batchAddGroupsToMemberUseCase,
    this.athleteId, {
    super.pageSize = 20,
  }) : _currentFilter = GroupsFilterCriteria();

  /// Updates the name filter and applies the updated criteria.
  void updateNameFilter(String name) {
    _currentFilter = _currentFilter.copyWith(name: name);
    applyCriteria(filterCriteria: _currentFilter);
  }

  @override
  Future<Result<List<Group>>> fetchItems(
    int pageKey,
    int pageSize, {
    FilterCriteria? filterCriteria,
    SortCriteria? sortCriteria,
  }) {
    return _getAllGroupsByPageUseCase.execute(
      pageKey,
      pageSize,
      filterCriteria: filterCriteria as GroupsFilterCriteria?,
    );
  }

  @override
  GroupView convertItem(Group item) => GroupView.fromDomain(item);

  @override
  Future<Result<void>> deleteItemFromService(GroupView item) {
    throw UnimplementedError(
        'Deletion is not supported in AthleteGroupsViewModel');
  }

  Future<Result<bool>> addGroupsToAthlete(
      List<String> groupIds, GroupRole role) async {
    final result =
        await _batchAddGroupsToMemberUseCase.execute(athleteId, groupIds, role);
    if (result.isSuccess) {
      return Result.success(true);
    } else {
      return Result.failure(result.error);
    }
  }
}

/// ViewModel for fetching groups an athlete is a member of.
class AthleteGroupsViewModel extends BaseAthleteGroupsViewModel {
  AthleteGroupsViewModel(
    GetAllGroupsByPageUseCase getAllGroupsByPageUseCase,
    BatchAddGroupsToMemberUseCase batchAddGroupsToMemberUseCase,
    String athleteId,
  ) : super(getAllGroupsByPageUseCase, batchAddGroupsToMemberUseCase,
            athleteId) {
    _currentFilter = _currentFilter.copyWith(withAthleteId: athleteId);
    applyCriteria(filterCriteria: _currentFilter);
  }
}

/// ViewModel for fetching potential groups an athlete can join.
class AthletePotentialGroupsViewModel extends BaseAthleteGroupsViewModel {
  AthletePotentialGroupsViewModel(
    GetAllGroupsByPageUseCase getAllGroupsByPageUseCase,
    BatchAddGroupsToMemberUseCase batchAddGroupsToMemberUseCase,
    String athleteId,
  ) : super(getAllGroupsByPageUseCase, batchAddGroupsToMemberUseCase,
            athleteId) {
    _currentFilter = _currentFilter.copyWith(withoutAthleteId: athleteId);
    applyCriteria(filterCriteria: _currentFilter);
  }
}
