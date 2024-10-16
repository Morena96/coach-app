import 'package:coach_app/shared/extensions/string.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StringExtension', () {
    group('capitalize', () {
      test('should capitalize the first letter of a string', () {
        expect('hello world'.capitalize(), equals('Hello world'));
        expect('flutter'.capitalize(), equals('Flutter'));
      });

      test('should return empty string if input is empty', () {
        expect(''.capitalize(), equals(''));
      });

      test('should return the same string if it starts with a number or symbol',
          () {
        expect('123abc'.capitalize(), equals('123abc'));
        expect('!hello'.capitalize(), equals('!hello'));
      });

      test('should handle single character strings', () {
        expect('a'.capitalize(), equals('A'));
        expect('Z'.capitalize(), equals('Z'));
      });
    });

    group('convertCamelCaseToSpacedUpperCase', () {
      test('should convert camelCase to spaced upper case', () {
        expect('helloWorld'.convertCamelCaseToSpacedUpperCase(),
            equals('Hello World'));
        expect('camelCaseString'.convertCamelCaseToSpacedUpperCase(),
            equals('Camel Case String'));
      });

      test('should return empty string if input is empty', () {
        expect(''.convertCamelCaseToSpacedUpperCase(), equals(''));
      });

      test('should handle strings with numbers', () {
        expect('user123Name'.convertCamelCaseToSpacedUpperCase(),
            equals('User123 Name'));
      });
    });
  });
}
