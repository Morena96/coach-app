import 'package:domain/features/logging/repositories/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:coach_app/features/antenna_system/presentation/providers/logs_provider.dart';
import 'package:coach_app/l10n.dart';

class TalkerScreen extends ConsumerStatefulWidget {
  final LoggerRepository logger;

  const TalkerScreen({super.key, required this.logger});

  @override
  ConsumerState<TalkerScreen> createState() => _TalkerScreenState();
}

class _TalkerScreenState extends ConsumerState<TalkerScreen> {
  final List<String> _logs = [];

  @override
  Widget build(BuildContext context) {
    // listen to logsProvider and add logs to _logs
    final logs = ref.watch(logsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.debugLogs),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              setState(() {
                _logs.clear();
              });
            },
          ),
        ],
      ),
      body: logs.when(
        data: (data) => ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            final log = data[index];
            return ListTile(
              title: Text(log),
            );
          },
        ),
        error: (error, stack) =>
            Center(child: Text(context.l10n.errorText(error))),
        loading: () => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 10),
              Text(context.l10n.waitingForLogs),
            ],
          ),
        ),
      ),
    );
  }
}
