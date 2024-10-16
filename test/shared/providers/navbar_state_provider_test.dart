import 'package:flutter_test/flutter_test.dart';
import 'package:coach_app/shared/providers/navbar_state_provider.dart';

void main() {
  group('NavbarState', () {
    test('should create NavbarState with correct values', () {
      final state = NavbarState(expanded: true, selectedItem: 'test');
      expect(state.expanded, true);
      expect(state.selectedItem, 'test');
    });

    test('copyWith should return a new instance with updated values', () {
      final original = NavbarState(expanded: true, selectedItem: 'original');
      final copied = original.copyWith(expanded: false, selectedItem: 'copied');

      expect(copied.expanded, false);
      expect(copied.selectedItem, 'copied');
      expect(original.expanded, true); // Original should remain unchanged
      expect(original.selectedItem, 'original');
    });

    test('copyWith should not change unspecified values', () {
      final original = NavbarState(expanded: true, selectedItem: 'original');
      final copied = original.copyWith(expanded: false);

      expect(copied.expanded, false);
      expect(copied.selectedItem, 'original');
    });
  });
}
