import 'package:coach_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:coach_app/core/widgets/app_dropdown.dart';
import 'package:coach_app/features/settings/presentation/providers/settings_view_model.dart';
import 'package:coach_app/l10n.dart';

/// A widget that allows selecting the app's language settings with a round appearance.
class SettingsLanguageSelector extends ConsumerWidget {
  const SettingsLanguageSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsState = ref.watch(settingsViewModelProvider);

    return settingsState.when(
      data: (_) {
        final viewModel = ref.read(settingsViewModelProvider.notifier);
        final currentLocale = viewModel.locale;

        return AppDropdown<String>(
          value: currentLocale.languageCode == 'system'
              ? 'system'
              : currentLocale.languageCode,
          foregroundColor: AppColors.black,
          backgroundColor: AppColors.white,
          items: [
            DropdownMenuItem(
                value: 'en', child: Text(context.l10n.englishLanguage)),
            DropdownMenuItem(
                value: 'es', child: Text(context.l10n.spanishLanguage)),
            DropdownMenuItem(
                value: 'fr', child: Text(context.l10n.frenchLanguage)),
          ],
          onChanged: (String? newValue) {
            if (newValue != null) {
              viewModel.setLanguage(newValue);
            }
          },
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (error, _) => Text(context.l10n.errorText(error)),
    );
  }
}
