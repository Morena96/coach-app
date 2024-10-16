import 'package:domain/features/shared/utilities/validation/validation_error.dart';
import 'package:domain/features/shared/utilities/validation/validation_result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ValidationResult', () {
    test('should be valid when created with no errors', () {
      final result = ValidationResult([]);
      expect(result.isValid, true);
      expect(result.errors, isEmpty);
    });

    test('should be invalid when created with errors', () {
      final result = ValidationResult([
        ValidationError('field1', 'Error message 1'),
        ValidationError('field2', 'Error message 2'),
      ]);
      expect(result.isValid, false);
      expect(result.errors.length, 2);
    });

    test('ValidationResult.valid() factory should create a valid result', () {
      final result = ValidationResult.valid();
      expect(result.isValid, true);
      expect(result.errors, isEmpty);
    });

    test('ValidationResult.invalid() factory should create an invalid result',
        () {
      final errors = [
        ValidationError('field1', 'Error message 1'),
        ValidationError('field2', 'Error message 2'),
      ];
      final result = ValidationResult.invalid(errors);
      expect(result.isValid, false);
      expect(result.errors, equals(errors));
    });

    test('addError should add a new error to the list', () {
      final result = ValidationResult.valid();
      expect(result.isValid, true);

      result.addError('field1', 'New error message');
      expect(result.isValid, false);
      expect(result.errors.length, 1);
      expect(result.errors.first.key, 'field1');
      expect(result.errors.first.message, 'New error message');
    });

    test('errorMap should correctly group errors by field', () {
      final result = ValidationResult([
        ValidationError('field1', 'Error 1 for field1'),
        ValidationError('field2', 'Error 1 for field2'),
        ValidationError('field1', 'Error 2 for field1'),
        ValidationError('field3', 'Error 1 for field3'),
      ]);

      final errorMap = result.errorMap;
      expect(errorMap.length, 3);
      expect(errorMap['field1'], ['Error 1 for field1', 'Error 2 for field1']);
      expect(errorMap['field2'], ['Error 1 for field2']);
      expect(errorMap['field3'], ['Error 1 for field3']);
    });

    test('errorMap should return an empty map for a valid result', () {
      final result = ValidationResult.valid();
      expect(result.errorMap, isEmpty);
    });

    test(
        'isValid should return true even after calling errorMap on a valid result',
        () {
      final result = ValidationResult.valid();
      result.errorMap; // Access errorMap
      expect(result.isValid, true);
    });

    test('multiple addError calls should accumulate errors', () {
      final result = ValidationResult.valid();
      result.addError('field1', 'Error 1');
      result.addError('field2', 'Error 2');
      result.addError('field1', 'Error 3');

      expect(result.isValid, false);
      expect(result.errors.length, 3);
      expect(result.errorMap['field1'], ['Error 1', 'Error 3']);
      expect(result.errorMap['field2'], ['Error 2']);
    });
  });
}
