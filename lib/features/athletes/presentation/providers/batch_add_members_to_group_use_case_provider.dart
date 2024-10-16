import 'package:application/athletes/use_cases/batch_add_members_to_group_use_case.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:coach_app/features/athletes/presentation/providers/members_provider.dart';

part 'batch_add_members_to_group_use_case_provider.g.dart';

/// Provides an instance of [BatchAddMembersToGroupUseCase]
@riverpod
BatchAddMembersToGroupUseCase batchAddMembersToGroupUseCase(
    BatchAddMembersToGroupUseCaseRef ref) {
  final membersRepository = ref.watch(membersProvider);
  return BatchAddMembersToGroupUseCase(membersRepository);
}
