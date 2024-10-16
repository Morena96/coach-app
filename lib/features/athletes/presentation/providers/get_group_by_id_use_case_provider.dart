import 'package:application/athletes/use_cases/get_group_use_case.dart';
import 'package:coach_app/features/athletes/presentation/providers/groups_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_group_by_id_use_case_provider.g.dart';

@riverpod
GetGroupByIdUseCase getGroupByIdUseCase(GetGroupByIdUseCaseRef ref) {
  final groups = ref.watch(groupsProvider);
  return GetGroupByIdUseCase(groups);
}
