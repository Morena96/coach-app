
import 'package:hive/hive.dart';

import 'hive_log_level_adapter.dart';

part 'hive_log_entry_adapter.g.dart';

@HiveType(typeId: 11)
class HiveLogEntry {
  @HiveField(0)
  final HiveLogLevel level;

  @HiveField(1)
  final String message;

  @HiveField(2)
  final DateTime timestamp;

  @HiveField(3)
  final String? error;

  @HiveField(4)
  final String? stackTrace;

  HiveLogEntry({
    required this.level,
    required this.message,
    required this.timestamp,
    this.error,
    this.stackTrace,
  });

  factory HiveLogEntry.fromJson(Map<String, dynamic> json) => HiveLogEntry(
    level: HiveLogLevel.values[json['level'] as int],
    message: json['message'] as String,
    timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp'] as int),
    error: json['error'] as String?,
    stackTrace: json['stackTrace'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'level': level.index,
    'message': message,
    'timestamp': timestamp.millisecondsSinceEpoch,
    'error': error,
    'stackTrace': stackTrace,
  };
}