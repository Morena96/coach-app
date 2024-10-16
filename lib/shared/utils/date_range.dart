import 'package:flutter/material.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';

import 'package:coach_app/l10n.dart';
import 'package:coach_app/shared/extensions/date_time.dart';

extension DateRangeX on DateRange {
  /// Formats a date range as a string.
  ///
  /// If [start] and [end] are on the same day (ignoring time),
  /// it returns a single date. Otherwise, it returns a range
  /// in the format 'dd/MM/yyyy-dd/MM/yyyy'.
  String formatForLocale(BuildContext context) {
    if (start.isSameDayWith(end)) {
      return start.formatForLocale(context);
    } else {
      return '${start.formatForLocale(context)}'
          '-${end.formatForLocale(context)}';
    }
  }
}

/// Returns a list of [QuickDateRange] objects for various time periods
List<QuickDateRange> getQuickDateRanges(BuildContext context) {
  final now = DateTime.now();
  final yesterday = now.subtract(const Duration(days: 1));
  final thisWeekStart = now.startOfWeek;
  final lastWeekStart = thisWeekStart.subtract(const Duration(days: 7));
  final twoWeeksAgoStart = thisWeekStart.subtract(const Duration(days: 14));
  final lastMonthStart = DateTime(now.year, now.month - 1, 1);
  final lastYearStart = DateTime(now.year - 1, 1, 1);

  return [
    QuickDateRange(
      label: context.l10n.today,
      dateRange: DateRange(now.startOfDay, now.endOfDay),
    ),
    QuickDateRange(
      label: context.l10n.yesterday,
      dateRange: DateRange(yesterday.startOfDay, yesterday.endOfDay),
    ),
    QuickDateRange(
      label: context.l10n.thisWeek,
      dateRange: DateRange(thisWeekStart, now.endOfWeek),
    ),
    QuickDateRange(
      label: context.l10n.lastWeek,
      dateRange: DateRange(lastWeekStart, lastWeekStart.endOfWeek),
    ),
    QuickDateRange(
      label: context.l10n.pastTwoWeeks,
      dateRange: DateRange(twoWeeksAgoStart, now.endOfWeek),
    ),
    QuickDateRange(
      label: context.l10n.thisMonth,
      dateRange: DateRange(now.startOfMonth, now.endOfMonth),
    ),
    QuickDateRange(
      label: context.l10n.lastMonth,
      dateRange: DateRange(lastMonthStart, lastMonthStart.endOfMonth),
    ),
    QuickDateRange(
      label: context.l10n.thisYear,
      dateRange: DateRange(now.startOfYear, now.endOfYear),
    ),
    QuickDateRange(
      label: context.l10n.lastYear,
      dateRange: DateRange(lastYearStart, lastYearStart.endOfYear),
    ),
  ];
}
