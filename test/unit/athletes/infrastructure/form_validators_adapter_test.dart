import 'package:coach_app/features/athletes/infrastructure/adapters/form_validators_adapter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FormValidatorsAdapter adapter;

  setUp(() {
    adapter = FormValidatorsAdapter();
  });

  group('isMinLength', () {
    test('should return null for valid length', () {
      expect(adapter.isMinLength('Hello', 3), isNull);
      expect(adapter.isMinLength('Hello', 5), isNull);
    });

    test('should return error message for invalid length', () {
      expect(adapter.isMinLength('Hi', 3), isNotNull);
    });

    test('should handle edge cases', () {
      expect(adapter.isMinLength('', 0), isNull);
      expect(adapter.isMinLength('Hello', 0), isNull);
    });
  });

  group('isRequired', () {
    test('should return null for non-empty values', () {
      expect(adapter.isRequired('Hello'), isNull);
      expect(adapter.isRequired('0'), isNull);
    });

    test('should return error message for empty or null values', () {
      expect(adapter.isRequired(''), isNotNull);
      expect(adapter.isRequired(null), isNotNull);
    });

    test('should handle edge cases', () {
      expect(adapter.isRequired(' '),
          isNull); // Note: This might be considered valid, adjust if needed
    });
  });
}
