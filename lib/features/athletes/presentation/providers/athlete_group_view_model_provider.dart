import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:coach_app/features/athletes/presentation/providers/athlete_groups_view_model.dart';
import 'package:coach_app/features/athletes/presentation/providers/batch_add_groups_to_member_use_case_provider.dart';
import 'package:coach_app/features/athletes/presentation/providers/get_all_groups_by_page_use_case_provider.dart';

final athleteGroupsViewModelProvider = StateNotifierProvider.autoDispose
    .family<AthleteGroupsViewModel, AsyncValue<void>, String>((ref, athleteId) {
  final getAllGroupsByPageUseCase =
      ref.watch(getAllGroupsByPageUseCaseProvider);
  final batchAddGroupsToMemberUseCase =
      ref.watch(batchAddGroupsToMemberUseCaseProvider);

  return AthleteGroupsViewModel(
    getAllGroupsByPageUseCase,
    batchAddGroupsToMemberUseCase,
    athleteId,
  );
});

final athletePotentialGroupsViewModelProvider = StateNotifierProvider
    .autoDispose
    .family<AthletePotentialGroupsViewModel, AsyncValue<void>, String>(
        (ref, athleteId) {
  final getAllGroupsByPageUseCase =
      ref.watch(getAllGroupsByPageUseCaseProvider);

  final batchAddGroupsToMemberUseCase =
      ref.watch(batchAddGroupsToMemberUseCaseProvider);

  return AthletePotentialGroupsViewModel(
    getAllGroupsByPageUseCase,
    batchAddGroupsToMemberUseCase,
    athleteId,
  );
});
