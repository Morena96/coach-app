import 'package:coach_app/shared/extensions/int.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('IntX', () {
    test('ms getter should return correct Duration in milliseconds', () {
      expect(500.ms, equals(const Duration(milliseconds: 500)));
      expect(0.ms, equals(Duration.zero));
      expect((-100).ms, equals(const Duration(milliseconds: -100)));
    });

    test('s getter should return correct Duration in seconds', () {
      expect(30.s, equals(const Duration(seconds: 30)));
      expect(0.s, equals(Duration.zero));
      expect((-5).s, equals(const Duration(seconds: -5)));
    });

    test('chaining ms and s getters should work correctly', () {
      final duration = 2.s + 500.ms;
      expect(duration, equals(const Duration(milliseconds: 2500)));
    });
  });
}
