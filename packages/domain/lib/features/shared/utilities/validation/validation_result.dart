import 'package:domain/features/shared/utilities/validation/validation_error.dart';

class ValidationResult {
  final List<ValidationError> errors;

  ValidationResult(this.errors);

  bool get isValid => errors.isEmpty;

  factory ValidationResult.valid() => ValidationResult([]);

  factory ValidationResult.invalid(List<ValidationError> errors) =>
      ValidationResult(errors);

  void addError(String key, String message) {
    errors.add(ValidationError(key, message));
  }

  Map<String, List<String>> get errorMap {
    final map = <String, List<String>>{};
    for (var error in errors) {
      map.putIfAbsent(error.key, () => []).add(error.message);
    }
    return map;
  }
}
