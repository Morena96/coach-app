import 'package:coach_app/shared/utils/app_validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppValidator', () {
    group('nonEmptyString', () {
      final validator = AppValidator.nonEmptyString('Field is required');

      test('should return null for non-empty string', () {
        expect(validator('Hello'), isNull);
      });

      test('should return error message for empty string', () {
        expect(validator(''), 'Field is required');
      });

      test('should return error message for null', () {
        expect(validator(null), 'Field is required');
      });
    });

    group('nonEmptyList', () {
      final validator = AppValidator.nonEmptyList('List is required');

      test('should return null for non-empty list', () {
        expect(validator([1, 2, 3]), isNull);
      });

      test('should return error message for empty list', () {
        expect(validator([]), 'List is required');
      });

      test('should return error message for null', () {
        expect(validator(null), 'List is required');
      });
    });

    group('email', () {
      final validator = AppValidator.email();

      test('should return null for valid email', () {
        expect(validator('test@example.com'), isNull);
      });

      test('should return error message for invalid email', () {
        expect(validator('invalid-email'), 'Enter a valid email address');
      });

      test('should return error message for empty string', () {
        expect(validator(''), 'Email is required');
      });

      test('should return error message for null', () {
        expect(validator(null), 'Email is required');
      });
    });

    group('minLength', () {
      final validator =
          AppValidator.minLength(5, 'Minimum 5 characters required');

      test('should return null for string with sufficient length', () {
        expect(validator('Hello World'), isNull);
      });

      test('should return error message for string with insufficient length',
          () {
        expect(validator('Hi'), 'Minimum 5 characters required');
      });

      test('should return error message for null', () {
        expect(validator(null), 'Minimum 5 characters required');
      });
    });

    group('phoneNumber', () {
      final validator = AppValidator.phoneNumber();

      test('should return null for valid phone number', () {
        expect(validator('+1234567890'), isNull);
        expect(validator('123-456-7890'), isNull);
      });

      test('should return error message for invalid phone number', () {
        expect(validator('123'), 'Enter a valid phone number');
        expect(validator('abcdefghij'), 'Enter a valid phone number');
      });

      test('should return error message for empty string', () {
        expect(validator(''), 'Phone number is required');
      });

      test('should return error message for null', () {
        expect(validator(null), 'Phone number is required');
      });
    });

    group('numericRange', () {
      final validator =
          AppValidator.numericRange(1, 100, 'Value must be between 1 and 100');

      test('should return null for value within range', () {
        expect(validator('50'), isNull);
      });

      test('should return error message for value below range', () {
        expect(validator('0'), 'Value must be between 1 and 100');
      });

      test('should return error message for value above range', () {
        expect(validator('101'), 'Value must be between 1 and 100');
      });

      test('should return error message for non-numeric string', () {
        expect(validator('abc'), 'Value must be between 1 and 100');
      });

      test('should return error message for empty string', () {
        expect(validator(''), 'This field is required');
      });

      test('should return error message for null', () {
        expect(validator(null), 'This field is required');
      });
    });

    group('combine', () {
      final combinedValidator = AppValidator.combine([
        AppValidator.nonEmptyString('Field is required'),
        AppValidator.minLength(5, 'Minimum 5 characters required'),
      ]);

      test('should return null when all validators pass', () {
        expect(combinedValidator('Hello World'), isNull);
      });

      test('should return first error message when a validator fails', () {
        expect(combinedValidator(''), 'Field is required');
        expect(combinedValidator('Hi'), 'Minimum 5 characters required');
      });
    });
  });
}
