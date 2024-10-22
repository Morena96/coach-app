import 'package:domain/features/sessions/services/session_validation_service.dart';
import 'package:domain/features/athletes/services/validation_library.dart';
import 'package:domain/features/shared/utilities/validation/validation_error.dart';
import 'package:domain/features/shared/utilities/validation/validation_result.dart';

class SessionValidationServiceImpl implements SessionValidationService {
  @override
  final ValidationLibrary validationLibrary;

  SessionValidationServiceImpl(this.validationLibrary);

  @override
  ValidationResult validateSessionData(Map<String, dynamic> sessionData) {
    final errors = <ValidationError>[];

    String? titleError = validationLibrary.isRequired(sessionData['title']);

    if (titleError != null) {
      errors.add(ValidationError('title', titleError));
    }
    // Add more validation rules as needed
    return errors.isEmpty
        ? ValidationResult.valid()
        : ValidationResult.invalid(errors);
  }
}
