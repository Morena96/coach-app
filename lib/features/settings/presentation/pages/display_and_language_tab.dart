import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:coach_app/core/theme/app_text_style.dart';
import 'package:coach_app/features/settings/presentation/providers/settings_view_model.dart';
import 'package:coach_app/features/settings/presentation/widgets/settings_language_selector.dart';
import 'package:coach_app/features/settings/presentation/widgets/settings_theme_mode_selector.dart';
import 'package:coach_app/l10n.dart';

class DisplayAndLanguageTab extends ConsumerStatefulWidget {
  const DisplayAndLanguageTab({super.key});

  @override
  ConsumerState<DisplayAndLanguageTab> createState() =>
      _DisplayAndLanguageTabState();
}

class _DisplayAndLanguageTabState extends ConsumerState<DisplayAndLanguageTab> {
  @override
  Widget build(BuildContext context) {
    final settingsState = ref.watch(settingsViewModelProvider);

    return settingsState.when(
      data: (settings) {
        final viewModel = ref.read(settingsViewModelProvider.notifier);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              context.l10n.language,
              style: AppTextStyle.primary20b,
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.languageSubtitle,
              style: AppTextStyle.secondary16r,
            ),
            const SizedBox(height: 20),
            Text(
              context.l10n.language,
              style: AppTextStyle.primary16r,
            ),
            const SizedBox(height: 8),
            const SettingsLanguageSelector(),
            const SizedBox(height: 20),
            Text(
              context.l10n.displayMode,
              style: AppTextStyle.primary20b,
            ),
            const SizedBox(height: 8),
            SettingsThemeModeSelector(
              selectedMode: viewModel.themeMode,
              onModeChanged: (ThemeMode newMode) {
                viewModel.updateSetting(
                    'themeMode', newMode.toString().split('.').last);
              },
            ),
            const SizedBox(height: 8),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) =>
          Center(child: Text(context.l10n.errorText(error))),
    );
  }
}
