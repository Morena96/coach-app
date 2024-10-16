import 'package:application/athletes/use_cases/create_group_use_case.dart';
import 'package:domain/features/athletes/services/group_validation_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:coach_app/features/athletes/presentation/providers/group_validation_service_provider.dart';
import 'package:coach_app/features/athletes/presentation/providers/groups_provider.dart';
import 'package:coach_app/features/avatars/infrastructure/provider/avatar_repository_provider.dart';

part 'create_group_use_case_provider.g.dart';

@riverpod
CreateGroupUseCase createNewGroupUseCase(CreateNewGroupUseCaseRef ref) {
  final groups = ref.watch(groupsProvider);
  final avatarRepository = ref.watch(avatarRepositoryProvider);
  final GroupValidationService validationService =
      ref.watch(groupValidationServiceProvider);

  return CreateGroupUseCase(groups, avatarRepository, validationService);
}
