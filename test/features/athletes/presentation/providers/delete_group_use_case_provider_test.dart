import 'package:application/athletes/use_cases/delete_group_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:coach_app/features/athletes/presentation/providers/delete_group_use_case_provider.dart';
import 'package:coach_app/features/athletes/presentation/providers/groups_provider.dart';

import '../../../../mocks.mocks.dart';

void main() {
  test(
      'deleteGroupUseCaseProvider creates DeleteGroupUseCase with correct dependency',
      () {
    final mockGroups = MockGroups();

    final container = ProviderContainer(
      overrides: [
        groupsProvider.overrideWithValue(mockGroups),
      ],
    );

    final useCase = container.read(deleteGroupUseCaseProvider);
    expect(useCase, isA<DeleteGroupUseCase>());
  });
}
