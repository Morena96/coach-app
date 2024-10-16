import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:coach_app/features/antenna_system/presentation/providers/antenna_system_provider.dart';
import 'package:coach_app/features/antenna_system/presentation/widgets/antenna_list_item.dart';
import 'package:coach_app/l10n.dart';
import 'package:coach_app/shared/extensions/context.dart';

class AntennaSystemPage extends ConsumerWidget {
  const AntennaSystemPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final antennaSystemState = ref.watch(antennaSystemStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.antennaSystemStatus),
      ),
      body: antennaSystemState.when(
        data: (state) {
          final (systemState, antennas) = state;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  context.l10n
                      .systemState(systemState.toString().split('.').last),
                  style: context.textTheme.headlineMedium,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: antennas.length,
                  itemBuilder: (context, index) => AntennaListItem(
                    antenna: antennas[index],
                    index: index,
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) =>
            Center(child: Text(context.l10n.errorText(error))),
      ),
    );
  }
}
