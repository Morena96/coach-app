import 'package:application/athletes/use_cases/update_group_use_case.dart';
import 'package:coach_app/features/athletes/presentation/providers/group_validation_service_provider.dart';
import 'package:coach_app/features/athletes/presentation/providers/groups_provider.dart';
import 'package:coach_app/features/avatars/infrastructure/provider/avatar_repository_provider.dart';
import 'package:domain/features/athletes/repositories/groups.dart';
import 'package:domain/features/athletes/services/group_validation_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'update_group_use_case_provider.g.dart';

@riverpod
UpdateGroupUseCase updateGroupUseCase(UpdateGroupUseCaseRef ref) {
  final Groups groups = ref.watch(groupsProvider);
  final GroupValidationService validationService =
      ref.watch(groupValidationServiceProvider);
  final avatarRepository = ref.watch(avatarRepositoryProvider);

  return UpdateGroupUseCase(groups, validationService, avatarRepository);
}
