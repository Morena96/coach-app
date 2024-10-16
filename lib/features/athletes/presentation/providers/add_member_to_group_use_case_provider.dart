import 'package:application/athletes/use_cases/add_member_to_group_use_case.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:coach_app/features/athletes/presentation/providers/members_provider.dart';

part 'add_member_to_group_use_case_provider.g.dart';

/// Provides an instance of [AddMemberToGroupUseCase]
@riverpod
AddMemberToGroupUseCase addMemberToGroupUseCase(
    AddMemberToGroupUseCaseRef ref) {
  final membersRepository = ref.watch(membersProvider);
  return AddMemberToGroupUseCase(membersRepository);
}
