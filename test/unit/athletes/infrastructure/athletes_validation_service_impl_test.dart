// test/features/athletes/infrastructure/services/athlete_validation_service_impl_test.dart

import 'package:domain/features/athletes/services/validation_library.dart';
import 'package:coach_app/features/athletes/infrastructure/services/athletes_validation_service_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'athletes_validation_service_impl_test.mocks.dart';

@GenerateMocks([ValidationLibrary])
void main() {
  late AthleteValidationServiceImpl validationService;
  late MockValidationLibrary mockValidationLibrary;

  setUp(() {
    mockValidationLibrary = MockValidationLibrary();
    validationService = AthleteValidationServiceImpl(mockValidationLibrary);
  });

  test('should return valid result for valid athlete data', () {
    // Arrange
    final athleteData = {'id': '1', 'name': 'John Doe'};
    when(mockValidationLibrary.isRequired(any)).thenReturn(null);
    when(mockValidationLibrary.isMinLength(any, any)).thenReturn(null);

    // Act
    final result = validationService.validateAthleteData(athleteData);

    // Assert
    expect(result.isValid, true);
  });

  test('should return invalid result for missing name', () {
    // Arrange
    final athleteData = {'name': null};
    when(mockValidationLibrary.isRequired(null)).thenReturn('Required Field');

    // Act
    final result = validationService.validateAthleteData(athleteData);

    // Assert
    expect(result.isValid, false);
    expect(result.errors.length, 1);
    expect(result.errors.first.key, 'name');
  });

  // Add more tests for other validation scenarios
}
