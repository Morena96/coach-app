import 'package:coach_app/features/antenna_system/presentation/providers/logs_provider.dart';
import 'package:coach_app/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LogsTab extends ConsumerStatefulWidget {
  const LogsTab({super.key});

  @override
  ConsumerState<LogsTab> createState() => _LogsTabState();
}

class _LogsTabState extends ConsumerState<LogsTab> {
  @override
  Widget build(BuildContext context) {
    final logsStream = ref.watch(logsProvider);

    return logsStream.when(
      data: (logs) {
        return ListView.builder(
            shrinkWrap: true,
            itemCount: logs.length,
            itemBuilder: (context, index) {
              return Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                child: Text(
                  logs[index],
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              );
            });
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) =>
          Center(child: Text(context.l10n.errorText(error.toString()))),
    );
  }
}
