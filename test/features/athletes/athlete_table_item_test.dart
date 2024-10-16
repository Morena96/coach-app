import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:coach_app/core/widgets/blurry_toast.dart';
import 'package:coach_app/features/athletes/presentation/models/athlete_view.dart';
import 'package:coach_app/features/athletes/presentation/models/sport_view.dart';
import 'package:coach_app/features/athletes/presentation/providers/athletes_view_model.dart';
import 'package:coach_app/features/athletes/presentation/providers/athletes_view_model_provider.dart';
import 'package:coach_app/features/athletes/presentation/widgets/athlete_table_item.dart';
import 'package:coach_app/shared/providers/directory_provider.dart';

// Generate mocks
import '../../widget_tree.dart';
@GenerateMocks([AthletesViewModel, Directory])
import 'athlete_table_item_test.mocks.dart';

void main() {
  late AthleteView mockAthlete;
  late MockAthletesViewModel mockViewModel;
  late MockDirectory mockDirectory;

  setUp(() {
    mockAthlete = const AthleteView(
      id: '1',
      name: 'John Doe',
      avatarPath: '',
      sports: [SportView(id: '2', name: 'Athletic')],
      groups: [],
    );
    mockViewModel = MockAthletesViewModel();
    mockDirectory = MockDirectory();
  });

  Widget createWidgetUnderTest() {
    return ProviderScope(
      overrides: [
        athletesViewModelProvider.overrideWith((ref) => mockViewModel),
        directoryProvider.overrideWithValue(mockDirectory),
      ],
      child: createWidgetTree(
        child: AthleteTableItem(athlete: mockAthlete),
      ),
    );
  }

  group('AthleteTableItem', () {
    testWidgets('displays athlete name and sport type',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('Athletic'), findsOneWidget);
    });

    testWidgets('shows delete confirmation dialog on trash icon tap',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();
      expect(find.byType(AthleteDeleteRestoreConfirmDialog), findsOneWidget);
    });

    testWidgets('calls deleteItem when confirmed and shows success toast',
        (WidgetTester tester) async {
      when(mockViewModel.deleteItem(mockAthlete)).thenAnswer((_) async => true);

      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Archive the athlete'));
      await tester.pumpAndSettle();

      verify(mockViewModel.deleteItem(mockAthlete)).called(1);
      expect(find.text('Athlete archived'), findsOneWidget);
      expect(find.byType(BlurryToast), findsOneWidget);
    });

    testWidgets('shows failure toast when deleteItem fails',
        (WidgetTester tester) async {
      when(mockViewModel.deleteItem(mockAthlete))
          .thenAnswer((_) async => false);

      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Archive the athlete'));
      await tester.pumpAndSettle();

      verify(mockViewModel.deleteItem(mockAthlete)).called(1);
      expect(find.text('Failed to archive athlete'), findsOneWidget);
    });
  });

  group('_AthleteDeleteConfirmDialog', () {
    testWidgets('has two buttons with correct labels',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createWidgetTree(
          child: AthleteDeleteRestoreConfirmDialog(athlete: mockAthlete),
        ),
      );

      expect(find.text('Archive the athlete'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('Delete button returns true', (WidgetTester tester) async {
      bool? result;
      await tester.pumpWidget(
        createWidgetTree(
          child: Builder(
            builder: (BuildContext context) {
              return ElevatedButton(
                child: const Text('Show Dialog'),
                onPressed: () async {
                  result = await showDialog<bool>(
                    context: context,
                    builder: (_) =>
                        AthleteDeleteRestoreConfirmDialog(athlete: mockAthlete),
                  );
                },
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Archive the athlete'));
      await tester.pumpAndSettle();

      expect(result, isTrue);
    });

    testWidgets('Cancel button returns false', (WidgetTester tester) async {
      bool? result;
      await tester.pumpWidget(
        createWidgetTree(
          child: Builder(
            builder: (BuildContext context) {
              return ElevatedButton(
                child: const Text('Show Dialog'),
                onPressed: () async {
                  result = await showDialog<bool>(
                    context: context,
                    builder: (_) =>
                        AthleteDeleteRestoreConfirmDialog(athlete: mockAthlete),
                  );
                },
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(result, isFalse);
    });
  });
}
