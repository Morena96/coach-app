import 'package:application/athletes/use_cases/get_all_groups_by_page_use_case.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:coach_app/features/athletes/presentation/providers/groups_provider.dart';

part 'get_all_groups_by_page_use_case_provider.g.dart';

@riverpod
GetAllGroupsByPageUseCase getAllGroupsByPageUseCase(
    GetAllGroupsByPageUseCaseRef ref) {
  final groups = ref.watch(groupsProvider);
  return GetAllGroupsByPageUseCase(groups);
}
