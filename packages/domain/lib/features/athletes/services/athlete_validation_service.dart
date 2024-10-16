import 'package:domain/features/athletes/services/validation_library.dart';
import 'package:domain/features/shared/utilities/validation/validation_result.dart';

abstract class AthleteValidationService {
  final ValidationLibrary validationLibrary;

  ValidationResult validateAthleteData(Map<String, dynamic> athleteData);

  AthleteValidationService(this.validationLibrary);
}
