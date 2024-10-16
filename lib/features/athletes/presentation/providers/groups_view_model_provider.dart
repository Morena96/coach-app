import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:coach_app/features/athletes/presentation/providers/create_group_use_case_provider.dart';
import 'package:coach_app/features/athletes/presentation/providers/delete_group_use_case_provider.dart';
import 'package:coach_app/features/athletes/presentation/providers/get_all_groups_by_page_use_case_provider.dart';
import 'package:coach_app/features/athletes/presentation/providers/get_group_by_id_use_case_provider.dart';
import 'package:coach_app/features/athletes/presentation/providers/groups_view_model.dart';
import 'package:coach_app/features/athletes/presentation/providers/restore_group_use_case_provider.dart';
import 'package:coach_app/features/athletes/presentation/providers/update_group_use_case_provider.dart';

final groupsViewModelProvider =
    StateNotifierProvider.autoDispose<GroupsViewModel, AsyncValue<void>>((ref) {
  // Cache this provider and its dependencies
  ref.keepAlive();

  final getAllGroupsByPageUseCase =
      ref.watch(getAllGroupsByPageUseCaseProvider);
  final deleteGroupUseCase = ref.watch(deleteGroupUseCaseProvider);
  final restoreGroupUseCase = ref.watch(restoreGroupUseCaseProvider);
  final getGroupByIdUseCase = ref.watch(getGroupByIdUseCaseProvider);
  final createNewGroupUseCase = ref.watch(createNewGroupUseCaseProvider);
  final updateGroupUseCase = ref.watch(updateGroupUseCaseProvider);

  return GroupsViewModel(
    getAllGroupsByPageUseCase,
    deleteGroupUseCase,
    restoreGroupUseCase,
    getGroupByIdUseCase,
    createNewGroupUseCase,
    updateGroupUseCase,
  );
});
