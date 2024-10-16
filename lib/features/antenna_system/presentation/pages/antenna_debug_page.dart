import 'package:domain/features/antenna_system/entities/antenna_info.dart';
import 'package:domain/features/antenna_system/repositories/antenna_system_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:coach_app/features/antenna_system/presentation/pages/talker_screen.dart';
import 'package:coach_app/features/antenna_system/presentation/providers/antenna_system_provider.dart';
import 'package:coach_app/features/antenna_system/presentation/widgets/antenna_debug_card.dart';
import 'package:coach_app/l10n.dart';
import 'package:coach_app/shared/extensions/context.dart';
import 'package:coach_app/shared/providers/logger_provider.dart';

class AntennaDebugPage extends ConsumerWidget {
  const AntennaDebugPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final antennaSystemState = ref.watch(antennaSystemStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.antennaDebug),
        actions: [
          IconButton(
            icon: const Icon(Icons.bug_report),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    TalkerScreen(logger: ref.read(loggerProvider)),
              ),
            ),
          ),
        ],
      ),
      body: antennaSystemState.when(
        data: (state) => _buildContent(context, ref, state),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) =>
            Center(child: Text(context.l10n.errorText(error))),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref,
      (AntennaSystemState, List<AntennaInfo>) state) {
    final (systemState, antennas) = state;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            context.l10n.systemState(systemState.toString().split('.').last),
            style: context.textTheme.headlineMedium,
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: antennas.length,
            itemBuilder: (context, index) => AntennaDebugCard(
              // random id for the key so it's always rebuilt
              key: ValueKey(antennas[index].portName),
              antenna: antennas[index],
            ),
          ),
        ),
      ],
    );
  }
}
