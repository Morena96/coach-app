

import 'package:hive/hive.dart';

part 'hive_log_level_adapter.g.dart';

@HiveType(typeId: 12)
enum HiveLogLevel {
  @HiveField(0)
  debug,
  @HiveField(1)
  info,
  @HiveField(2)
  warning,
  @HiveField(3)
  error
}

// The Hive generator will automatically create the adapter
// No need for a manual LogLevelAdapter implementation
