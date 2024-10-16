import 'package:domain/features/athletes/services/group_validation_service.dart';
import 'package:domain/features/athletes/services/validation_library.dart';
import 'package:domain/features/shared/utilities/validation/validation_error.dart';
import 'package:domain/features/shared/utilities/validation/validation_result.dart';

class GroupsValidationServiceImpl implements GroupValidationService {
  @override
  final ValidationLibrary validationLibrary;

  GroupsValidationServiceImpl(this.validationLibrary);

  @override
  ValidationResult validateGroupData(Map<String, dynamic> athleteData) {
    final errors = <ValidationError>[];

    String? nameError = validationLibrary.isRequired(athleteData['name']);
    String? descriptionError =
        validationLibrary.isMaxLength(athleteData['description'], 320);

    errors.addAll([
      if (nameError != null) ValidationError('name', nameError),
      if (descriptionError != null)
        ValidationError('description', descriptionError),
    ]);

    // Add more validation rules as needed
    return errors.isEmpty
        ? ValidationResult.valid()
        : ValidationResult.invalid(errors);
  }
}
