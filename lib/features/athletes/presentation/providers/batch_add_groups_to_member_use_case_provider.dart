import 'package:application/athletes/use_cases/batch_add_groups_to_member_use_case.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:coach_app/features/athletes/presentation/providers/members_provider.dart';

part 'batch_add_groups_to_member_use_case_provider.g.dart';

@riverpod
BatchAddGroupsToMemberUseCase batchAddGroupsToMemberUseCase(
    BatchAddGroupsToMemberUseCaseRef ref) {
  final membersRepository = ref.watch(membersProvider);
  return BatchAddGroupsToMemberUseCase(membersRepository);
}
