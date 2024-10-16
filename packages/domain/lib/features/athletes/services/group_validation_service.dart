import 'package:domain/features/athletes/services/validation_library.dart';
import 'package:domain/features/shared/utilities/validation/validation_result.dart';

abstract class GroupValidationService {
  final ValidationLibrary validationLibrary;

  ValidationResult validateGroupData(Map<String, dynamic> groupData);

  GroupValidationService(this.validationLibrary);
}
