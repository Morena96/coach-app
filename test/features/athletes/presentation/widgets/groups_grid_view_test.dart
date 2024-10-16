import 'package:coach_app/shared/providers/directory_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:coach_app/core/widgets/screens/error_screen.dart';
import 'package:coach_app/features/athletes/presentation/models/group_view.dart';
import 'package:coach_app/features/athletes/presentation/providers/groups_view_model_provider.dart';
import 'package:coach_app/features/athletes/presentation/providers/groups_view_model.dart';
import 'package:coach_app/features/athletes/presentation/widgets/group_table_item.dart';
import 'package:coach_app/features/athletes/presentation/widgets/groups_grid_view.dart';

import '../../../../unit/avatars/infrastructure/offline_first_avatar_repository_test.mocks.dart';
import '../../../../widget_tree.dart';
@GenerateMocks([GroupsViewModel])
import 'groups_grid_view_test.mocks.dart';

void main() {
  late MockGroupsViewModel mockViewModel;
  late PagingController<int, GroupView> pagingController;

  setUp(() {
    mockViewModel = MockGroupsViewModel();
    pagingController = PagingController<int, GroupView>(firstPageKey: 0);
    when(mockViewModel.pagingController).thenReturn(pagingController);
  });

  Widget createTestWidget() {
    final directory = MockDirectory();

    return ProviderScope(
      overrides: [
        directoryProvider.overrideWithValue(directory),
        groupsViewModelProvider.overrideWith((ref) => mockViewModel),
      ],
      child: createWidgetTree(
        child: const GroupsGridView(),
      ),
    );
  }

  testWidgets('GroupsGridView displays groups correctly',
      (WidgetTester tester) async {
    // Arrange
    final groups = [
      const GroupView(id: '2', name: 'Group 2', members: []),
      const GroupView(id: '1', name: 'Group 1', members: []),
    ];
    pagingController.appendPage(groups, 1);

    // Act
    await tester.pumpWidget(createTestWidget());

    // Assert
    expect(find.byType(GroupTableItem), findsNWidgets(2));
    expect(find.text('Group 1'), findsOneWidget);
    expect(find.text('Group 2'), findsOneWidget);
  });

  testWidgets('GroupsGridView displays error screen on first page error',
      (WidgetTester tester) async {
    // Arrange
    pagingController.error = 'Test error';

    // Act
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    // Assert
    expect(find.byType(ErrorScreen), findsOneWidget);
  });

  testWidgets('GroupsGridView displays no items found message when empty',
      (WidgetTester tester) async {
    // Arrange
    pagingController.appendLastPage([]);

    // Act
    await tester.pumpWidget(createTestWidget());

    // Assert
    expect(find.text('No groups found'), findsOneWidget);
  });

  testWidgets('GroupsGridView refreshes on pull down',
      (WidgetTester tester) async {
    // Arrange
    pagingController.appendPage([], 0);

    // Act
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    // Find the first scrollable widget
    final scrollable = find.byType(Scrollable).first;
    await tester.drag(scrollable, const Offset(0, 300));
    await tester.pumpAndSettle();

    // Assert
    verify(mockViewModel.refresh()).called(1);
  });
}
