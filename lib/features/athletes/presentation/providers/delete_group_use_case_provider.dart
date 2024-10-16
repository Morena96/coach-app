import 'package:application/athletes/use_cases/delete_group_use_case.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:coach_app/features/athletes/presentation/providers/groups_provider.dart';

part 'delete_group_use_case_provider.g.dart';

@riverpod
DeleteGroupUseCase deleteGroupUseCase(DeleteGroupUseCaseRef ref) {
  final groups = ref.watch(groupsProvider);
  return DeleteGroupUseCase(groups);
}
