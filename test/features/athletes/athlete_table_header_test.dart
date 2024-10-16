import 'package:coach_app/features/athletes/presentation/providers/athletes_view_model_provider.dart';
import 'package:domain/features/athletes/value_objects/athlete_sort_criteria.dart';
import 'package:domain/features/shared/value_objects/sort_order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:coach_app/core/theme/app_text_style.dart';
import 'package:coach_app/core/widgets/table_header_col.dart';
import 'package:coach_app/features/athletes/presentation/widgets/athlete_table_header.dart';

import '../../widget_tree.dart';
import 'athlete_table_item_test.mocks.dart';

void main() {
  late MockAthletesViewModel mockViewModel;

  setUp(() {
    mockViewModel = MockAthletesViewModel();
    when(mockViewModel.currentSort)
        .thenReturn(AthleteSortCriteria(field: '', order: SortOrder.ascending));
  });

  Widget createTestWidget({required Widget child}) {
    return ProviderScope(
      overrides: [
        athletesViewModelProvider.overrideWith((_) => mockViewModel),
      ],
      child: createWidgetTree(
        child: child,
      ),
    );
  }

  testWidgets('AthleteTableHeader has TableHeaderCol widgets',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      createTestWidget(
        child: const AthleteTableHeader(),
      ),
    );

    // Test TableHeaderCol widgets
    expect(find.byType(TableHeaderCol), findsExactly(3));

    // Test TableHeaderCol properties
    final nameHeader = find.widgetWithText(TableHeaderCol, 'Name');
    final sportHeader = find.widgetWithText(TableHeaderCol, 'Sport');
    final actionHeader = find.widgetWithText(TableHeaderCol, 'Action');

    expect(tester.widget<TableHeaderCol>(nameHeader).onSort, isNotNull);
    expect(tester.widget<TableHeaderCol>(sportHeader).onSort, isNull);
    expect(tester.widget<TableHeaderCol>(actionHeader).onSort, isNull);

    // Pump all remaining microtasks
    await tester.pumpAndSettle();
  });

  testWidgets('TableHeaderCol renders correctly when not sortable',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      createTestWidget(
        child: const TableHeaderCol(title: 'Test Column'),
      ),
    );

    // Check if the text is rendered
    expect(find.text('Test Column'), findsOneWidget);

    // Check if the text style is correct
    final textWidget = tester.widget<Text>(find.text('Test Column'));
    expect(
        textWidget.style,
        equals(AppTextStyle.secondary14r
            .copyWith(color: const Color(0x80ffffff))));

    // Ensure that the sort icon is not present
    expect(find.byType(SvgPicture), findsNothing);

    // Ensure that InkWell is not present
    expect(find.byType(InkWell), findsNothing);
  });

  testWidgets('TableHeaderCol renders correctly when sortable',
      (WidgetTester tester) async {
    bool sortTapped = false;

    await tester.pumpWidget(
      createTestWidget(
        child: TableHeaderCol(
          title: 'Test Column',
          onSort: () => sortTapped = true,
        ),
      ),
    );

    // Check if the text is rendered
    expect(find.text('Test Column'), findsOneWidget);

    // Check if the text style is correct
    final textWidget = tester.widget<Text>(find.text('Test Column'));
    expect(
        textWidget.style,
        equals(AppTextStyle.secondary14r
            .copyWith(color: const Color(0x80ffffff))));

    // Check if the sort icon is present
    expect(find.byType(SvgPicture), findsOneWidget);

    // Check if InkWell is present
    expect(find.byType(InkWell), findsOneWidget);

    // Test the onSort callback
    await tester.tap(find.byType(InkWell));
    expect(sortTapped, isTrue);
  });
}
