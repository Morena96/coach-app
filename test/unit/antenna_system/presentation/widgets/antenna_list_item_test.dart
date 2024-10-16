import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:domain/features/antenna_system/entities/antenna_info.dart';
import 'package:coach_app/features/antenna_system/presentation/widgets/antenna_list_item.dart';

import '../../../../widget_tree.dart';

void main() {
  group('AntennaListItem', () {
    final testAntenna = AntennaInfo(
      portName: 'COM3',
      description: 'Test Antenna',
      serialNumber: '123456',
      vendorId: 12,
      productId: 12,
    );

    Widget createTestWidget({required Widget child}) {
      return createWidgetTree(
        child: child,
      );
    }

    testWidgets('renders ExpansionTile with correct title',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: AntennaListItem(antenna: testAntenna, index: 0),
        ),
      );

      expect(find.text('Antenna 1'), findsOneWidget);
    });

    testWidgets('expands to show antenna details', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: AntennaListItem(antenna: testAntenna, index: 0),
        ),
      );

      // Initially, the details should not be visible
      expect(find.text('Port: COM3'), findsNothing);
      expect(find.text('Description: Test Antenna'), findsNothing);
      expect(find.text('Serial Number: 123456'), findsNothing);

      // Tap to expand the tile
      await tester.tap(find.text('Antenna 1'));
      await tester.pumpAndSettle();

      // After expansion, the details should be visible
      expect(find.text('Port: COM3'), findsOneWidget);
      expect(find.text('Description: Test Antenna'), findsOneWidget);
      expect(find.text('Serial Number: 123456'), findsOneWidget);
    });

    testWidgets('index is correctly used in title',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: AntennaListItem(antenna: testAntenna, index: 2),
        ),
      );

      expect(find.text('Antenna 3'), findsOneWidget);
    });
  });
}
