import 'package:domain/features/athletes/services/validation_library.dart';
import 'package:domain/features/shared/utilities/validation/validation_result.dart';

abstract class SessionValidationService {
  final ValidationLibrary validationLibrary;

  ValidationResult validateSessionData(Map<String, dynamic> sessionData);

  SessionValidationService(this.validationLibrary);
}
