abstract class ValidationLibrary {
  String? isRequired(String? value);

  String? isMinLength(String? value, int minLength);

  String? isMaxLength(String? value, int maxLength);
}
