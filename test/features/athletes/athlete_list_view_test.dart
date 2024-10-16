// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:coach_app/features/athletes/presentation/providers/athletes_view_model_provider.dart';
import 'package:coach_app/shared/providers/directory_provider.dart';
import 'package:domain/features/athletes/value_objects/athlete_sort_criteria.dart';
import 'package:domain/features/shared/value_objects/sort_order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:coach_app/core/widgets/screens/error_screen.dart';
import 'package:coach_app/features/athletes/presentation/models/athlete_view.dart';
import 'package:coach_app/features/athletes/presentation/models/sport_view.dart';
import 'package:coach_app/features/athletes/presentation/providers/athletes_view_model.dart';
import 'package:coach_app/features/athletes/presentation/widgets/athlete_list_view.dart';
import 'package:coach_app/features/athletes/presentation/widgets/athlete_table_header.dart';
import 'package:coach_app/features/athletes/presentation/widgets/athlete_table_item.dart';

import '../../widget_tree.dart';
@GenerateMocks([AthletesViewModel, Directory])
import 'athlete_list_view_test.mocks.dart';

void main() {
  late MockAthletesViewModel mockViewModel;
  late PagingController<int, AthleteView> pagingController;
  late MockDirectory mockDirectory;

  setUp(() {
    mockViewModel = MockAthletesViewModel();
    pagingController = PagingController<int, AthleteView>(firstPageKey: 0);
    mockDirectory = MockDirectory();
    when(mockViewModel.pagingController).thenReturn(pagingController);
    when(mockViewModel.currentSort)
        .thenReturn(AthleteSortCriteria(field: '', order: SortOrder.ascending));
  });

  Widget createTestWidget() {
    return ProviderScope(
      overrides: [
        athletesViewModelProvider.overrideWith((ref) => mockViewModel),
        directoryProvider.overrideWithValue(mockDirectory),
      ],
      child: createWidgetTree(
        child: const AthleteListView(),
      ),
    );
  }

  testWidgets('AthleteListView displays athletes correctly',
      (WidgetTester tester) async {
    // Arrange
    final athletes = [
      const AthleteView(
          id: '1',
          name: 'John Doe',
          avatarPath: '',
          sports: [SportView(id: '1', name: 'Running')],
          groups: []),
      const AthleteView(
          id: '2',
          name: 'Jane Smith',
          avatarPath: '',
          sports: [SportView(id: '2', name: 'Swimming')],
          groups: []),
    ];
    pagingController.appendPage(athletes, 1);

    // Act
    await tester.pumpWidget(createTestWidget());

    // Assert
    expect(find.byType(AthleteTableHeader), findsOneWidget);
    expect(find.byType(AthleteTableItem), findsNWidgets(2));
    expect(find.text('John Doe'), findsOneWidget);
    expect(find.text('Jane Smith'), findsOneWidget);
  });

  testWidgets('AthleteListView displays error screen on first page error',
      (WidgetTester tester) async {
    // Arrange
    pagingController.error = 'Test error';

    // Act
    await tester.pumpWidget(createTestWidget());

    // Print the elements that are on the page
    await tester.pumpAndSettle();

    // Assert
    expect(find.byType(ErrorScreen), findsOneWidget);
  });

  testWidgets('AthleteListView displays no items found message when empty',
      (WidgetTester tester) async {
    // Arrange
    pagingController.appendLastPage([]);

    // Act
    await tester.pumpWidget(createTestWidget());

    // Assert
    expect(find.text('No athletes found'), findsOneWidget);
  });

  testWidgets('AthleteListView refreshes on pull down',
      (WidgetTester tester) async {
    // Arrange
    pagingController.appendPage([], 0);

    // Act
    await tester.pumpWidget(createTestWidget());

    await tester.pumpAndSettle();

    // Find the first scrollable widget (likely a ListView or similar)
    final scrollable = find.byType(Scrollable).first;
    await tester.drag(scrollable, const Offset(0, 300));
    await tester.pumpAndSettle();

    // Assert
    verify(mockViewModel.refresh()).called(1);
  });
}
