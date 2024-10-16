import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:coach_app/core/app_state.dart';
import 'package:coach_app/core/theme/app_colors.dart';
import 'package:coach_app/core/theme/app_text_style.dart';
import 'package:coach_app/core/widgets/app_divider.dart';
import 'package:coach_app/features/athletes/presentation/models/athlete_view.dart';
import 'package:coach_app/features/sessions/presentation/models/battery_level.dart';
import 'package:coach_app/features/sessions/presentation/models/signal_quality.dart';
import 'package:coach_app/features/sessions/presentation/widgets/live_session_athlete_card.dart';
import 'package:coach_app/features/sessions/presentation/widgets/live_session_timer.dart';

class HelloWorldPage extends ConsumerWidget {
  const HelloWorldPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appStateProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Showcase'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Icon(
              appState.isConnected ? Icons.wifi : Icons.wifi_off_outlined,
              color: appState.isConnected
                  ? AppColors.primaryGreen
                  : AppColors.additionalRed,
              size: 24,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            const LiveSessionTimer(seconds: 1234),
            const SizedBox(height: 16),
            const SizedBox(
              width: 400,
              child: LiveSessionAthleteCard(
                athlete: AthleteView(
                    id: 'id',
                    name: 'John Smith',
                    avatarPath: '',
                    sports: [],
                    groups: []),
                batteryLevel: BatteryLevel.high,
                signalQuality: SignalQuality.medium,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Filter Multiselect',
              style: AppTextStyle.primary18b,
            ),
            const SizedBox(height: 16),
            const Text(
              'Primary 18 bold',
              style: AppTextStyle.primary18b,
            ),
            const SizedBox(height: 16),
            const Text(
              'Primary 14 regular',
              style: AppTextStyle.primary14r,
            ),
            const SizedBox(height: 16),
            const Text(
              'Secondary 14 regular',
              style: AppTextStyle.secondary14r,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Elevated Button'),
            ),
            const SizedBox(height: 16),
            const ElevatedButton(
              onPressed: null,
              child: Text('Disabled Elevated Button with long text'),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {},
              child: const Text('Outlined Button'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {},
              child: const Text('Text Button'),
            ),
            const SizedBox(height: 16),
            IconButton(
              icon: const Icon(Icons.thumb_up),
              onPressed: () {},
            ),
            const SizedBox(height: 16),
            FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.add),
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Enter text (hint)',
              ),
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              title: const Text('Checkbox'),
              value: true,
              onChanged: (bool? value) {},
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Switch'),
              value: true,
              onChanged: (bool value) {},
            ),
            const SizedBox(height: 16),
            Slider(
              value: 0.5,
              onChanged: (double value) {},
            ),
            const SizedBox(height: 16),
            RadioListTile(
              title: const Text('Radio Button'),
              value: 1,
              groupValue: 1,
              onChanged: (int? value) {},
            ),
            const SizedBox(height: 16),
            const Chip(
              label: Text('Chip'),
            ),
            const SizedBox(height: 16),
            const AppDivider(),
            const SizedBox(height: 16),
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            const LinearProgressIndicator(),
            const SizedBox(height: 16),
            DropdownButton<String>(
              value: 'One',
              onChanged: (String? newValue) {},
              items: <String>['One', 'Two', 'Three', 'Four']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            AlertDialog(
              title: const Text('Alert'),
              content: const Text('This is an alert dialog.'),
              actions: [
                TextButton(
                  onPressed: () {},
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('OK'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
