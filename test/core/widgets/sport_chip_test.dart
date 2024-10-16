import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:coach_app/core/theme/app_colors.dart';
import 'package:coach_app/core/theme/app_text_style.dart';
import 'package:coach_app/core/widgets/sport_chip.dart';
import 'package:coach_app/features/athletes/presentation/models/sport_view.dart';

void main() {
  testWidgets('SportChip displays sport name correctly',
      (WidgetTester tester) async {
    const sportName = 'Football';
    const sport = SportView(id: '1', name: sportName);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SportChip(sport: sport),
        ),
      ),
    );

    // Verify that the sport name is displayed
    expect(find.text(sportName), findsOneWidget);
  });

  testWidgets('SportChip has correct styling', (WidgetTester tester) async {
    const sportName = 'Basketball';
    const sport = SportView(id: '2', name: sportName);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SportChip(sport: sport),
        ),
      ),
    );

    // Find the Container widget
    final containerFinder = find.byType(Container);
    expect(containerFinder, findsOneWidget);

    final container = tester.widget<Container>(containerFinder);

    // Verify the container's decoration
    final decoration = container.decoration as BoxDecoration;
    expect(decoration.border, isA<Border>());
    expect(decoration.border!.top.color, AppColors.grey300);
    expect(decoration.borderRadius, BorderRadius.circular(19));

    // Verify the text style
    final textFinder = find.byType(Text);
    final text = tester.widget<Text>(textFinder);
    expect(text.style, AppTextStyle.primary14r);
  });
}
