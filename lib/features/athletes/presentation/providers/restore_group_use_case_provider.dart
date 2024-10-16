import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:application/athletes/use_cases/restore_group_use_case.dart';

import 'package:coach_app/features/athletes/presentation/providers/groups_provider.dart';

part 'restore_group_use_case_provider.g.dart';

@riverpod
RestoreGroupUseCase restoreGroupUseCase(RestoreGroupUseCaseRef ref) {
  final groups = ref.watch(groupsProvider);
  return RestoreGroupUseCase(groups);
}
