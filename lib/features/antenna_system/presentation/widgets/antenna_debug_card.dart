import 'package:coach_app/l10n.dart';
import 'package:coach_app/shared/extensions/context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:coach_app/core/theme/app_colors.dart';
import 'package:domain/features/antenna_system/entities/antenna_info.dart';
import 'package:coach_app/features/antenna_system/presentation/providers/antenna_command_provider.dart';
import 'package:coach_app/features/antenna_system/presentation/providers/antenna_receive_provider.dart';
import 'package:coach_app/shared/providers/logger_provider.dart';

class AntennaDebugCard extends ConsumerStatefulWidget {
  final AntennaInfo antenna;

  const AntennaDebugCard({super.key, required this.antenna});

  @override
  ConsumerState<AntennaDebugCard> createState() => _AntennaDebugCardState();
}

class _AntennaDebugCardState extends ConsumerState<AntennaDebugCard> {
  final TextEditingController _commandController = TextEditingController();
  final ScrollController _logScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  void _sendCommand(WidgetRef ref) async {
    final command = _commandController.text;
    if (command.isNotEmpty) {
      final useCase = ref.read(sendAntennaCommandUseCaseProvider);
      await useCase(widget.antenna.portName, command);
      _commandController.clear();
      ref
          .read(loggerProvider)
          .info('Command sent to ${widget.antenna.portName}: $command');
    }
  }

  @override
  void dispose() {
    _commandController.dispose();
    _logScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dataStream =
        ref.watch(antennaDataStreamProvider(widget.antenna.portName));
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.antenna(widget.antenna.serialNumber),
            style: context.textTheme.titleLarge,
          ),
          Text(
            '${context.l10n.status}: ${context.l10n.connected}',
            style: context.textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commandController,
                  style: const TextStyle(color: AppColors.black),
                  decoration: InputDecoration(
                    hintText: context.l10n.enterCommand,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () => _sendCommand(ref),
                child: Text(context.l10n.send),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '${context.l10n.dataStream}:',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  height: 225,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: dataStream.when(
                    data: (data) => SingleChildScrollView(
                        controller: _logScrollController,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: data.reversed
                                .map((message) => Text(message))
                                .toList(growable: false))),
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, stack) =>
                        Text(context.l10n.errorText(error)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
