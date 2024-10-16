import 'package:domain/features/athletes/services/validation_library.dart';
import 'package:form_validator/form_validator.dart';

class FormValidatorsAdapter extends ValidationLibrary {
  @override
  String? isMinLength(String? value, int minLength) {
    return ValidationBuilder(optional: true)
        .minLength(minLength)
        .build()(value);
  }

  @override
  String? isMaxLength(String? value, int maxLength) {
    return ValidationBuilder(optional: true)
        .maxLength(maxLength)
        .build()(value);
  }

  @override
  String? isRequired(String? value) {
    return ValidationBuilder().build()(value);
  }
}
