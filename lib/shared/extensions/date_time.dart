import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  /// Returns the start of the day (00:00:00)
  DateTime get startOfDay => DateTime(year, month, day);

  /// Returns the end of the day (23:59:59)
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59);

  /// Returns the start of the current week (Sunday)
  DateTime get startOfWeek {
    return subtract(Duration(days: weekday % 7)).startOfDay;
  }

  /// Returns the end of the current week (Saturday)
  DateTime get endOfWeek => startOfWeek.add(const Duration(days: 6)).endOfDay;

  /// Returns the start of the current month
  DateTime get startOfMonth => DateTime(year, month, 1);

  /// Returns the end of the current month
  DateTime get endOfMonth => DateTime(year, month + 1, 0).endOfDay;

  /// Returns the start of the current year
  DateTime get startOfYear => DateTime(year, 1, 1);

  /// Returns the end of the current year
  DateTime get endOfYear => DateTime(year, 12, 31).endOfDay;

  /// Returns a formatted string representation of the date
  String get formattedDate => DateFormat('MMM d, y').format(this);

  /// Checks if this date is the same day as another date
  bool isSameDayWith(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  /// Formats a date based on the given locale
  String formatForLocale(BuildContext context) {
    final locale = Localizations.localeOf(context);

    switch (locale.languageCode) {
      case 'fr':
        return DateFormat('dd/MM/yyyy').format(this);
      case 'es':
        return DateFormat('dd/MM/yyyy').format(this);
      default:
        return DateFormat('MM/dd/yyyy').format(this);
    }
  }
}
