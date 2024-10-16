import 'package:flutter/material.dart';

/// Utility class providing common form field validators.
class AppValidator {
  /// Validates that a string is not empty.
  static FormFieldValidator<String> nonEmptyString(String errorText) {
    return (value) {
      if (value == null || value.isEmpty) {
        return errorText;
      }
      return null;
    };
  }

  /// Validates that a string is not empty.
  static FormFieldValidator<List<Object>> nonEmptyList(String errorText) {
    return (value) {
      if (value == null || value.isEmpty) {
        return errorText;
      }
      return null;
    };
  }

  /// Validates that a string is a valid email address.
  static FormFieldValidator<String> email() {
    return (value) {
      if (value == null || value.isEmpty) {
        return 'Email is required';
      }
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(value)) {
        return 'Enter a valid email address';
      }
      return null;
    };
  }

  /// Validates that a string has a minimum length.
  static FormFieldValidator<String> minLength(int minLength, String errorText) {
    return (value) {
      if (value == null || value.length < minLength) {
        return errorText;
      }
      return null;
    };
  }

  /// Validates that a string is a valid phone number.
  static FormFieldValidator<String> phoneNumber() {
    return (value) {
      if (value == null || value.isEmpty) {
        return 'Phone number is required';
      }
      final phoneRegex = RegExp(r'^\+?[\d\s-]{10,14}$');
      if (!phoneRegex.hasMatch(value)) {
        return 'Enter a valid phone number';
      }
      return null;
    };
  }

  /// Validates that a value is within a specified numeric range.
  static FormFieldValidator<String> numericRange(
      double min, double max, String errorText) {
    return (value) {
      if (value == null || value.isEmpty) {
        return 'This field is required';
      }
      final numericValue = double.tryParse(value);
      if (numericValue == null || numericValue < min || numericValue > max) {
        return errorText;
      }
      return null;
    };
  }

  /// Combines multiple validators into a single validator.
  static FormFieldValidator<String> combine(
      List<FormFieldValidator<String>> validators) {
    return (value) {
      for (final validator in validators) {
        final result = validator(value);
        if (result != null) {
          return result;
        }
      }
      return null;
    };
  }
}
