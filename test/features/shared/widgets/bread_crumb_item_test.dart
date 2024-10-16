import 'package:flutter_test/flutter_test.dart';

import 'package:coach_app/features/shared/widgets/bread_crumb_item.dart';

void main() {
  group('BreadcrumbItem', () {
    test('should create a BreadcrumbItem with label', () {
      final item = BreadcrumbItem(label: 'Home');
      expect(item.label, equals('Home'));
      expect(item.onTap, isNull);
    });

    test('should create a BreadcrumbItem with label and onTap', () {
      bool tapped = false;
      final item = BreadcrumbItem(
        label: 'Products',
        onTap: () => tapped = true,
      );
      expect(item.label, equals('Products'));
      expect(item.onTap, isNotNull);

      item.onTap!();
      expect(tapped, isTrue);
    });
  });
}
