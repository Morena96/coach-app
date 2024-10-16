import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:coach_app/features/athletes/presentation/providers/add_member_to_group_use_case_provider.dart';
import 'package:coach_app/features/athletes/presentation/providers/batch_add_members_to_group_use_case_provider.dart';
import 'package:coach_app/features/athletes/presentation/providers/get_members_for_group_paginated_use_case_provider.dart';
import 'package:coach_app/features/athletes/presentation/providers/group_members_view_model.dart';
import 'package:coach_app/features/athletes/presentation/providers/remove_member_from_group_use_case_provider.dart';

/// Provider for the GroupMembersViewModel.
final groupMembersViewModelProvider = StateNotifierProvider.autoDispose
    .family<GroupMembersViewModel, AsyncValue<void>, String>((ref, groupId) {
  // Cache this provider and its dependencies
  ref.keepAlive();

  final getMembersForGroupPaginatedUseCase =
      ref.watch(getMembersForGroupPaginatedUseCaseProvider);
  final addMemberToGroupUseCase = ref.watch(addMemberToGroupUseCaseProvider);
  final batchAddMembersToGroupUseCase =
      ref.watch(batchAddMembersToGroupUseCaseProvider);
  final removeMemberFromGroupUseCase =
      ref.watch(removeMemberFromGroupUseCaseProvider);

  return GroupMembersViewModel(
    getMembersForGroupPaginatedUseCase,
    addMemberToGroupUseCase,
    batchAddMembersToGroupUseCase,
    removeMemberFromGroupUseCase,
    groupId,
  );
});
