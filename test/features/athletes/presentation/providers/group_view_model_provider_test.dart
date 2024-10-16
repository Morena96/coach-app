import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:coach_app/features/athletes/presentation/providers/delete_group_use_case_provider.dart';
import 'package:coach_app/features/athletes/presentation/providers/get_all_groups_by_page_use_case_provider.dart';
import 'package:coach_app/features/athletes/presentation/providers/get_group_by_id_use_case_provider.dart';
import 'package:coach_app/features/athletes/presentation/providers/groups_view_model_provider.dart';
import 'package:coach_app/features/athletes/presentation/providers/groups_view_model.dart';
import 'package:coach_app/features/athletes/presentation/providers/update_group_use_case_provider.dart';
import 'package:coach_app/shared/providers/directory_provider.dart';

import '../../../../unit/avatars/infrastructure/offline_first_avatar_repository_test.mocks.dart';
import 'groups_view_model_test.mocks.dart';

void main() {
  test(
      'groupsViewModelProvider creates GroupsViewModel with correct dependencies',
      () async {
    WidgetsFlutterBinding.ensureInitialized();

    final mockGetAllGroupsByPageUseCase = MockGetAllGroupsByPageUseCase();
    final mockDeleteGroupUseCase = MockDeleteGroupUseCase();
    final mockGetGroupByIdUseCase = MockGetGroupByIdUseCase();
    final mockUpdateGroupUseCase = MockUpdateGroupUseCase();

    final directory = MockDirectory();
    final container = ProviderContainer(
      overrides: [
        getAllGroupsByPageUseCaseProvider
            .overrideWithValue(mockGetAllGroupsByPageUseCase),
        deleteGroupUseCaseProvider.overrideWithValue(mockDeleteGroupUseCase),
        getGroupByIdUseCaseProvider.overrideWithValue(mockGetGroupByIdUseCase),
        updateGroupUseCaseProvider.overrideWithValue(mockUpdateGroupUseCase),
        directoryProvider.overrideWithValue(directory),
      ],
    );

    final viewModel = container.read(groupsViewModelProvider.notifier);

    expect(viewModel, isA<GroupsViewModel>());
  });
}
