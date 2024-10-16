/// Represents an exception that occurs during API calls.
///
/// This class encapsulates error information returned by the API,
/// including the error message, HTTP status code, and field-specific errors.
class ApiException implements Exception {
  /// The error message describing the exception.
  final String message;

  /// The HTTP status code associated with the exception, if applicable.
  final int? statusCode;

  /// A map of field-specific errors, where the key is the field name
  /// and the value is a list of error messages for that field.
  final Map<String, List<String>>? fieldErrors;

  /// Constructs an [ApiException] with the given [message], optional [statusCode],
  /// and optional [fieldErrors].
  ApiException({
    required this.message,
    this.statusCode,
    this.fieldErrors,
  });

  @override
  String toString() =>
      'ApiException: $message (Code: $statusCode)\n$fieldErrors';
}
