import 'package:application/athletes/use_cases/update_group_use_case.dart';
import 'package:coach_app/features/athletes/presentation/providers/groups_provider.dart';
import 'package:coach_app/features/athletes/presentation/providers/update_group_use_case_provider.dart';
import 'package:coach_app/shared/providers/directory_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../mocks.mocks.dart';
// Import your necessary files here

void main() {
  test(
      'updateGroupUseCaseProvider creates UpdateGroupUseCase with correct dependency',
      () {
    final mockGroups = MockGroups();

    final mockDirectory = MockDirectory();

    final container = ProviderContainer(
      overrides: [
        groupsProvider.overrideWithValue(mockGroups),
        directoryProvider.overrideWithValue(mockDirectory),
      ],
    );

    final useCase = container.read(updateGroupUseCaseProvider);

    expect(useCase, isA<UpdateGroupUseCase>());
  });
}
