import 'package:application/athletes/use_cases/get_members_for_group_paginated_use_case.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:coach_app/features/athletes/presentation/providers/athletes_provider.dart';
import 'package:coach_app/features/athletes/presentation/providers/members_provider.dart';

part 'get_members_for_group_paginated_use_case_provider.g.dart';

@riverpod
GetMembersForGroupPaginatedUseCase getMembersForGroupPaginatedUseCase(
    GetMembersForGroupPaginatedUseCaseRef ref) {
  final members = ref.watch(membersProvider);
  final athletes = ref.watch(athletesProvider);
  return GetMembersForGroupPaginatedUseCase(members, athletes);
}
