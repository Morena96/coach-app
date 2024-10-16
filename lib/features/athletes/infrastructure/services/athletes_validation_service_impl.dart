import 'package:domain/features/athletes/services/athlete_validation_service.dart';
import 'package:domain/features/athletes/services/validation_library.dart';
import 'package:domain/features/shared/utilities/validation/validation_error.dart';
import 'package:domain/features/shared/utilities/validation/validation_result.dart';

class AthleteValidationServiceImpl implements AthleteValidationService {
  @override
  final ValidationLibrary validationLibrary;

  AthleteValidationServiceImpl(this.validationLibrary);

  @override
  ValidationResult validateAthleteData(Map<String, dynamic> athleteData) {
    final errors = <ValidationError>[];

    String? nameError = validationLibrary.isRequired(athleteData['name']);

    if (nameError != null) {
      errors.add(ValidationError('name', nameError));
    }
    // Add more validation rules as needed
    return errors.isEmpty
        ? ValidationResult.valid()
        : ValidationResult.invalid(errors);
  }
}
