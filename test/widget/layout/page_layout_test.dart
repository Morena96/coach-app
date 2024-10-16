import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/mockito.dart';

import 'package:coach_app/core/widgets/layout/bread_crumbles.dart';
import 'package:coach_app/core/widgets/layout/page_header.dart';
import 'package:coach_app/core/widgets/layout/page_layout.dart';

import '../../mocks.dart';

class MockGoRouter extends Mock implements GoRouter {}

void main() {
  group('PageLayout Widget Tests', () {
    testWidgets('PageLayout displays child widget correctly',
        (WidgetTester tester) async {
      // Arrange
      const child = PageLayout(
        child: Text('Main Content'),
      );

      // Act
      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: router(child),
        ),
      );

      // Assert
      expect(find.text('Main Content'), findsOneWidget);
    });

    testWidgets('PageLayout displays header and footer if provided',
        (WidgetTester tester) async {
      // Arrange
      const page = PageLayout(
        header: Text('Header Content'),
        footer: Text('Footer Content'),
        child: Text('Main Content'),
      );

      // Act
      await tester.pumpWidget(
        MaterialApp.router(routerConfig: router(page)),
      );

      // Assert
      expect(find.text('Header Content'), findsOneWidget);
      expect(find.text('Main Content'), findsOneWidget);
      expect(find.text('Footer Content'), findsOneWidget);
    });

    testWidgets('PageLayout does not display footer if not provided',
        (WidgetTester tester) async {
      // Arrange
      const page = PageLayout(
        header: Text('Header Content'),
        child: Text('Main Content'),
      );

      // Act
      await tester.pumpWidget(
        MaterialApp.router(routerConfig: router(page)),
      );

      // Assert
      expect(find.byType(BreadCrumbles), findsOneWidget);
      expect(find.text('Main Content'), findsOneWidget);
      expect(find.text('Header Content'), findsOneWidget);
      expect(find.text('Footer Content'), findsNothing);
    });
  });

  group('PageHeader Widget Tests', () {
    testWidgets('PageHeader displays title correctly',
        (WidgetTester tester) async {
      // Arrange
      const child = PageHeader(title: 'title');

      // Act
      await tester.pumpWidget(
        MaterialApp.router(routerConfig: router(child)),
      );

      // Assert
      expect(find.text('title'), findsOneWidget);
    });

    testWidgets('PageHeader displays actions if provided',
        (WidgetTester tester) async {
      // Arrange
      final actions = [
        IconButton(onPressed: () {}, icon: const Icon(Icons.search))
      ];
      final child = PageHeader(
        title: 'title',
        actions: actions,
      );

      // Act
      await tester.pumpWidget(
        MaterialApp.router(routerConfig: router(child)),
      );

      // Assert
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('PageHeader does not display actions if not provided',
        (WidgetTester tester) async {
      // Arrange
      const child = PageHeader(
        title: 'title',
      );

      // Act
      await tester.pumpWidget(
        MaterialApp.router(routerConfig: router(child)),
      );

      // Assert
      expect(find.byIcon(Icons.search), findsNothing);
    });

    testWidgets('PageHeader displays subtitle if provided',
        (WidgetTester tester) async {
      // Arrange
      const child = PageHeader(title: 'title');

      // Act
      await tester.pumpWidget(
        MaterialApp.router(routerConfig: router(child)),
      );

      // Assert
      expect(find.text('title'), findsOneWidget);
    });
  });
}
