import 'package:application/athletes/use_cases/create_group_use_case.dart';
import 'package:coach_app/features/athletes/presentation/providers/create_group_use_case_provider.dart';
import 'package:coach_app/features/athletes/presentation/providers/groups_provider.dart';
import 'package:coach_app/features/avatars/infrastructure/provider/avatar_repository_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../mocks.mocks.dart';
// Import your necessary files here

void main() {
  test(
      'createNewGroupUseCaseProvider creates CreateGroupUseCase with correct dependencies',
      () {
    final mockGroups = MockGroups();
    final mockAvatarRepository = MockAvatarRepository();

    final container = ProviderContainer(
      overrides: [
        groupsProvider.overrideWithValue(mockGroups),
        avatarRepositoryProvider.overrideWithValue(mockAvatarRepository),
      ],
    );

    final useCase = container.read(createNewGroupUseCaseProvider);

    expect(useCase, isA<CreateGroupUseCase>());
  });
}
