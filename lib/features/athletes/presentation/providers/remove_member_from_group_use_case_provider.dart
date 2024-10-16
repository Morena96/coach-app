import 'package:application/athletes/use_cases/remove_member_from_group_use_case.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:coach_app/features/athletes/presentation/providers/members_provider.dart';

part 'remove_member_from_group_use_case_provider.g.dart';

/// Provides an instance of [RemoveMemberFromGroupUseCase]
@riverpod
RemoveMemberFromGroupUseCase removeMemberFromGroupUseCase(
    RemoveMemberFromGroupUseCaseRef ref) {
  final membersRepository = ref.watch(membersProvider);
  return RemoveMemberFromGroupUseCase(membersRepository);
}
