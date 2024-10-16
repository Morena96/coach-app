import 'dart:async';

import 'package:application/athletes/use_cases/add_member_to_group_use_case.dart';
import 'package:application/athletes/use_cases/batch_add_members_to_group_use_case.dart';
import 'package:application/athletes/use_cases/get_members_for_group_paginated_use_case.dart';
import 'package:application/athletes/use_cases/remove_member_from_group_use_case.dart';
import 'package:domain/features/athletes/entities/group_role.dart';
import 'package:domain/features/athletes/entities/member.dart';
import 'package:domain/features/athletes/entities/member_with_athlete.dart';
import 'package:domain/features/athletes/value_objects/athlete_sort_criteria.dart';
import 'package:domain/features/shared/utilities/result.dart';
import 'package:domain/features/shared/value_objects/filter_criteria.dart';
import 'package:domain/features/shared/value_objects/sort_criteria.dart';
import 'package:domain/features/shared/value_objects/sort_order.dart';

import 'package:coach_app/features/athletes/presentation/models/member_with_athlete_view.dart';
import 'package:coach_app/shared/view_models/paginated_view_model.dart';

class GroupMembersViewModel
    extends PaginatedViewModel<MemberWithAthleteView, MemberWithAthlete> {
  final GetMembersForGroupPaginatedUseCase _getMembersForGroupPaginatedUseCase;
  final AddMemberToGroupUseCase _addMemberToGroupUseCase;
  final BatchAddMembersToGroupUseCase _batchAddMembersToGroupUseCase;
  final RemoveMemberFromGroupUseCase _removeMemberFromGroupUseCase;
  final String _groupId;
  AthleteSortCriteria _currentSort;

  /// Creates a GroupMembersViewModel.
  ///
  /// [_getMembersForGroupPaginatedUseCase] is the use case for fetching paginated members.
  /// [_addMemberToGroupUseCase] is the use case for adding a member to the group.
  /// [_groupId] is the ID of the group whose members are being fetched.
  /// [initialSort] is the initial sorting criteria (defaults to sorting by name in ascending order).
  GroupMembersViewModel(
    this._getMembersForGroupPaginatedUseCase,
    this._addMemberToGroupUseCase,
    this._batchAddMembersToGroupUseCase,
    this._removeMemberFromGroupUseCase,
    this._groupId, {
    AthleteSortCriteria? initialSort,
  })  : _currentSort = initialSort ??
            AthleteSortCriteria(field: 'name', order: SortOrder.ascending),
        super(setupListener: false) {
    applyCriteria(sortCriteria: _currentSort, reload: false);
    setUpListener();
  }

  /// Current sort criteria for members.
  AthleteSortCriteria get currentSort => _currentSort;

  /// Updates the sort criteria and applies it.
  void updateSort(AthleteSortCriteria newSort) {
    _currentSort = newSort;
    applyCriteria(sortCriteria: _currentSort);
  }

  /// Toggles the current sort order.
  void toggleSortOrder() {
    final newOrder = _currentSort.order == SortOrder.ascending
        ? SortOrder.descending
        : SortOrder.ascending;
    updateSort(_currentSort.copyWith(order: newOrder));
  }

  /// Changes the sort field.
  void changeSortField(String field) {
    updateSort(_currentSort.copyWith(field: field));
  }

  @override
  Future<Result<List<MemberWithAthlete>>> fetchItems(
    int pageKey,
    int pageSize, {
    FilterCriteria? filterCriteria,
    SortCriteria? sortCriteria,
  }) {
    return _getMembersForGroupPaginatedUseCase.execute(
      _groupId,
      pageKey,
      pageSize,
    );
  }

  @override
  MemberWithAthleteView convertItem(MemberWithAthlete item) {
    return MemberWithAthleteView.fromDomain(item);
  }

  @override
  Future<Result<void>> deleteItemFromService(MemberWithAthleteView item) async {
    final result = await _removeMemberFromGroupUseCase.execute(
      _groupId,
      item.member.id,
    );
    return result;
  }

  Future<Result<void>> deleteMembersFromGroup(String memberIds) async {
    final result =
        await _removeMemberFromGroupUseCase.execute(_groupId, memberIds);
    if (result.isSuccess) refresh();
    return result;
  }

  /// Adds a new member to the group.
  ///
  /// Returns a [Result] indicating success or failure.
  Future<Result<Member>> addMemberToGroup(
      String athleteId, GroupRole role) async {
    final result =
        await _addMemberToGroupUseCase.execute(athleteId, _groupId, role);
    if (result.isSuccess) refresh();
    return result;
  }

  /// Adds a new member to the group.
  ///
  /// Returns a [Result] indicating success or failure.
  Future<Result<List<Member>>> batchAddMembersToGroup(
      List<String> athleteIds, GroupRole role) async {
    final result = await _batchAddMembersToGroupUseCase.execute(
        _groupId, athleteIds, role);
    if (result.isSuccess) refresh();
    return result;
  }
}
