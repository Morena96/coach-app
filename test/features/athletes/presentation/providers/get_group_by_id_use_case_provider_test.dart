import 'package:application/athletes/use_cases/get_group_use_case.dart';
import 'package:coach_app/features/athletes/presentation/providers/get_group_by_id_use_case_provider.dart';
import 'package:coach_app/features/athletes/presentation/providers/groups_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../mocks.mocks.dart';
// Import your necessary files here

void main() {
  test(
      'getGroupByIdUseCaseProvider creates GetGroupByIdUseCase with correct dependency',
      () {
    final mockGroups = MockGroups();

    final container = ProviderContainer(
      overrides: [
        groupsProvider.overrideWithValue(mockGroups),
      ],
    );

    final useCase = container.read(getGroupByIdUseCaseProvider);

    expect(useCase, isA<GetGroupByIdUseCase>());
  });
}
