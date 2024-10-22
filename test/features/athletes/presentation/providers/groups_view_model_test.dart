import 'package:application/athletes/use_cases/create_group_use_case.dart';
import 'package:application/athletes/use_cases/delete_group_use_case.dart';
import 'package:application/athletes/use_cases/get_all_groups_by_page_use_case.dart';
import 'package:application/athletes/use_cases/get_group_use_case.dart';
import 'package:application/athletes/use_cases/restore_group_use_case.dart';
import 'package:application/athletes/use_cases/update_group_use_case.dart';
import 'package:domain/features/athletes/entities/group.dart';
import 'package:domain/features/shared/utilities/result.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:coach_app/features/athletes/presentation/models/group_view.dart';
import 'package:coach_app/features/athletes/presentation/providers/groups_view_model.dart';
import 'package:coach_app/features/athletes/presentation/providers/groups_view_model_provider.dart';

@GenerateMocks([
  GetAllGroupsByPageUseCase,
  DeleteGroupUseCase,
  RestoreGroupUseCase,
  GetGroupByIdUseCase,
  CreateGroupUseCase,
  UpdateGroupUseCase
])
import 'groups_view_model_test.mocks.dart';

void main() {
  late MockGetAllGroupsByPageUseCase mockGetAllGroupsByPageUseCase;
  late MockDeleteGroupUseCase mockDeleteGroupUseCase;
  late MockRestoreGroupUseCase mockRestoreGroupUseCase;
  late MockGetGroupByIdUseCase mockGetGroupByIdUseCase;
  late MockCreateGroupUseCase mockCreateGroupUseCase;
  late MockUpdateGroupUseCase mockUpdateGroupUseCase;
  late GroupsViewModel groupsViewModel;
  late ProviderContainer container;

  setUp(() {
    mockGetAllGroupsByPageUseCase = MockGetAllGroupsByPageUseCase();
    mockDeleteGroupUseCase = MockDeleteGroupUseCase();
    mockRestoreGroupUseCase = MockRestoreGroupUseCase();
    mockGetGroupByIdUseCase = MockGetGroupByIdUseCase();
    mockCreateGroupUseCase = MockCreateGroupUseCase();
    mockUpdateGroupUseCase = MockUpdateGroupUseCase();

    when(mockGetAllGroupsByPageUseCase.execute(any, any,
            filterCriteria: anyNamed('filterCriteria')))
        .thenAnswer((_) async => Result.success([]));

    groupsViewModel = GroupsViewModel(
      mockGetAllGroupsByPageUseCase,
      mockDeleteGroupUseCase,
      mockRestoreGroupUseCase,
      mockGetGroupByIdUseCase,
      mockCreateGroupUseCase,
      mockUpdateGroupUseCase,
    );

    container = ProviderContainer(
      overrides: [
        groupsViewModelProvider.overrideWith((ref) => groupsViewModel),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('GroupsViewModel', () {
    test('initializes with correct default values', () {
      expect(groupsViewModel.pagingController.firstPageKey, 0);
      expect(groupsViewModel.pagingController.itemList, isEmpty);
      expect(groupsViewModel.state, isA<AsyncData>());
      expect(groupsViewModel.currentNameFilter, isEmpty);
      expect(groupsViewModel.currentSportsFilter, isEmpty);
    });

    test('fetchItems calls getAllGroupsByPageUseCase with correct parameters',
        () async {
      when(mockGetAllGroupsByPageUseCase.execute(any, any,
              filterCriteria: anyNamed('filterCriteria')))
          .thenAnswer((_) async => Result.success([]));

      await groupsViewModel.fetchItems(1, 50);

      verify(mockGetAllGroupsByPageUseCase.execute(1, 50,
              filterCriteria: anyNamed('filterCriteria')))
          .called(1);
    });

    test('convertItem correctly converts Group to GroupView', () {
      const group = Group(id: '1', name: 'Test Group');
      final groupView = groupsViewModel.convertItem(group);

      expect(groupView, isA<GroupView>());
      expect(groupView.id, group.id);
      expect(groupView.name, group.name);
    });

    test('deleteItemFromService calls deleteGroupUseCase with correct id',
        () async {
      const groupView = GroupView(id: '1', name: 'Test Group');
      when(mockDeleteGroupUseCase.execute(any))
          .thenAnswer((_) async => Result.success(null));

      await groupsViewModel.deleteItemFromService(groupView);

      verify(mockDeleteGroupUseCase.execute('1')).called(1);
    });

    test('updateNameFilter updates filter and applies criteria', () {
      groupsViewModel.updateNameFilter('Test');
      expect(groupsViewModel.currentNameFilter, 'Test');
    });

    test('getGroupById calls getGroupByIdUseCase', () async {
      when(mockGetGroupByIdUseCase.execute(any)).thenAnswer((_) async =>
          Result.success(
              const Group(id: '1', name: 'Test Group')));

      await groupsViewModel.getGroupById('1');

      verify(mockGetGroupByIdUseCase.execute('1')).called(1);
    });
  });
}
