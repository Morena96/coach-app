import 'package:coach_app/shared/extensions/string.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StringExtension', () {
    group('capitalize', () {
      test('should capitalize empty string', () {
        expect(''.capitalize(), '');
      });

      test('should capitalize single letter', () {
        expect('a'.capitalize(), 'A');
      });

      test('should capitalize first letter', () {
        expect('hello world'.capitalize(), 'Hello world');
      });

      test('should handle all uppercase string', () {
        expect('HELLO WORLD'.capitalize(), 'HELLO WORLD');
      });
    });

    group('convertCamelCaseToSpacedUpperCase', () {
      test('should convert empty string', () {
        expect(''.convertCamelCaseToSpacedUpperCase(), '');
      });

      test('should convert single letter', () {
        expect('a'.convertCamelCaseToSpacedUpperCase(), 'A');
      });

      test('should handle all uppercase string', () {
        expect('HELLO WORLD'.convertCamelCaseToSpacedUpperCase(),
            'H E L L O  W O R L D');
      });
    });
  });
}
