import 'package:binary_data_reader/main.dart';
import 'package:coach_app/core/widgets/app_dialog.dart';
import 'package:coach_app/features/antenna_system/presentation/view_model/set_config_data.dart';
import 'package:coach_app/features/antenna_system/presentation/widgets/set_config_form.dart';
import 'package:domain/features/antenna_system/entities/antenna_state.dart';
import 'package:domain/features/antenna_system/value_objects/antenna_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:coach_app/features/antenna_system/presentation/providers/antenna_state_machine_provider.dart';
import 'package:coach_app/features/antenna_system/presentation/providers/antenna_system_provider.dart';
import 'package:coach_app/features/antenna_system/presentation/providers/receive_commands_use_case_provider.dart';
import 'package:coach_app/features/antenna_system/presentation/providers/start_calibration_use_case_provider.dart';
import 'package:coach_app/l10n.dart';
import 'package:coach_app/shared/extensions/context.dart';

class AntennaControlPage extends ConsumerStatefulWidget {
  const AntennaControlPage({super.key});

  @override
  AntennaControlPageState createState() => AntennaControlPageState();
}

class AntennaControlPageState extends ConsumerState<AntennaControlPage> {
  final List<String> _logs = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final antennaSystemState = ref.watch(antennaSystemStateProvider);
    final antennaStateMachine = ref.watch(antennaStateMachineProvider);
    final receiveCommands = ref.watch(receiveCommandsUseCaseProvider);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.antennaControl)),
      body: antennaSystemState.when(
        data: (state) => Row(
          children: [
            // 1/4 column for command buttons
            Expanded(
              flex: 1,
              child: Card(
                margin: const EdgeInsets.all(16),
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    ElevatedButton(
                      onPressed: () async => await antennaStateMachine
                          .transitionToLiveMode(state.$2.first.portName),
                      child: Text(context.l10n.modeLive),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () async => await ref
                          .read(antennaStateMachineProvider)
                          .transitionToCommandMode(state.$2.isNotEmpty
                              ? state.$2.first.portName
                              : ''),
                      child: Text(context.l10n.modeCommand),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AppDialog(
                            title: context.l10n.setConfig,
                            content: SetConfigForm(
                              onSubmit: (SetConfigData data) {
                                ref.read(antennaStateMachineProvider).setConfig(
                                      AntennaConfig(
                                        masterId: data.masterId,
                                        frequency: data.frequency,
                                        mainFrequency: data.mainFrequency,
                                        isMain: data.isMain,
                                        clubId: data.clubId,
                                      ),
                                      state.$2.isNotEmpty
                                          ? state.$2.first.portName
                                          : '',
                                    );
                                Navigator.of(context).pop();
                              },
                            ),
                            actions: const [],
                          ),
                        );
                      },
                      child: Text(context.l10n.setConfig),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => ref
                          .read(antennaStateMachineProvider)
                          .setAllPodsToLive(state.$2.isNotEmpty
                              ? state.$2.first.portName
                              : ''),
                      child: Text(context.l10n.setAllPodsToLive),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => ref
                          .read(antennaStateMachineProvider)
                          .setAllPodsToStandby(state.$2.isNotEmpty
                              ? state.$2.first.portName
                              : ''),
                      child: Text(context.l10n.setAllPodsToStandby),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () =>
                          ref.read(startCalibrationUseCaseProvider).execute(),
                      child: Text(context.l10n.startCalibration),
                    ),
                    // Add more buttons for other commands as needed
                  ],
                ),
              ),
            ),
            // 3/4 column for command responses
            Expanded(
              flex: 3,
              child: Card(
                margin: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        context.l10n.antennaState(state),
                        style: context.textTheme.headlineMedium,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: StreamBuilder<AntennaState>(
                          stream: antennaStateMachine.stateStream,
                          builder: (context, snapshot) {
                            return Text(
                              context.l10n.currentState(
                                  snapshot.data?.name ?? 'Unknown'),
                              style: context.textTheme.headlineMedium,
                            );
                          }),
                    ),
                    Expanded(
                      child: receiveCommands.when(
                        data: (Command command) {
                          setState(() {
                            _logs.add(command.toString());
                          });
                          return ListView.builder(
                            itemCount: _logs.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 2.0),
                                child: Text(_logs[index],
                                    style: const TextStyle(fontSize: 12)),
                              );
                            },
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                          );
                        },
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (error, stack) =>
                            Center(child: Text(context.l10n.errorText(error))),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) =>
            Center(child: Text(context.l10n.errorText(error))),
      ),
    );
  }
}
