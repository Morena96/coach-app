import 'package:coach_app/features/antenna_system/presentation/providers/logs_provider.dart';
import 'package:coach_app/shared/providers/logger_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'logs_initializer.g.dart';

@Riverpod(keepAlive: true)
void logsInitializer(LogsInitializerRef ref) {
 ref.watch(loggerProvider);
 ref.watch(logsProvider);
}