enum LogLevel { debug, info, warning, error, critical, verbose }

class LogEntry {
  /// The severity level of the log entry.
  final LogLevel level;

  /// The main message of the log entry.
  final String message;

  /// Any error object associated with this log entry, if applicable.
  final dynamic error;

  /// The stack trace associated with the error, if available.
  final StackTrace? stackTrace;

  /// The timestamp when the log entry was created.
  final DateTime timestamp;

  /// Constructs a [LogEntry] with the given parameters.
  ///
  /// If [timestamp] is not provided, it defaults to the current time.
  LogEntry({
    required this.level,
    required this.message,
    this.error,
    this.stackTrace,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  @override
  String toString() {
    return '${timestamp.toIso8601String()} [${level.toString().toUpperCase()}] $message'
        '${error != null ? '\nError: $error' : ''}'
        '${stackTrace != null ? '\nStack Trace:\n$stackTrace' : ''}';
  }
}
