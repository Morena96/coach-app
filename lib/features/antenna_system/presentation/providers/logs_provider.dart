import 'package:coach_app/shared/providers/logger_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'logs_provider.g.dart';

@Riverpod(keepAlive: true)
Stream<List<String>> logs(LogsRef ref) async* {
  final logs = ref.watch(loggerProvider);

  var allMessages = const <String>[];

  await for (final message in logs.logStream) {
    allMessages = [...allMessages, message.toString()];
    yield allMessages;
  }
}
