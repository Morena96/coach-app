extension DurationExtension on Duration {
  /// Formats the duration as a string in the format "XXh YYm ZZs", omitting zero values.
  ///
  /// Example:
  /// ```dart
  /// Duration(hours: 2, minutes: 10, seconds: 14).toHHMMSS(); // Returns "2h 10m 14s"
  /// Duration(minutes: 5, seconds: 30).toHHMMSS(); // Returns "5m 30s"
  /// Duration(seconds: 45).toHHMMSS(); // Returns "45s"
  /// ```
  String toHHMMSS() {
    final hours = inHours;
    final minutes = inMinutes % 60;
    final seconds = inSeconds % 60;

    final List<String> parts = [];

    if (hours > 0) parts.add('${hours}h');
    if (minutes > 0 || parts.isNotEmpty) parts.add('${minutes}m');
    parts.add('${seconds}s');

    return parts.join(' ');
  }
}
