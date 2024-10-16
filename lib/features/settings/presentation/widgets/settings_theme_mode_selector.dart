import 'package:coach_app/l10n.dart';
import 'package:flutter/material.dart';

import 'package:coach_app/core/theme/app_colors.dart';
import 'package:coach_app/core/theme/app_text_style.dart';
import 'package:coach_app/shared/extensions/context.dart';

/// A widget that allows selecting the display mode using a segmented button.
class SettingsThemeModeSelector extends StatelessWidget {
  /// The currently selected display mode.
  final ThemeMode selectedMode;

  /// Callback function called when a new display mode is selected.
  final ValueChanged<ThemeMode> onModeChanged;

  const SettingsThemeModeSelector({
    super.key,
    required this.selectedMode,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.color.tertiary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: SegmentedButton<ThemeMode>(
        style: ButtonStyle(
          iconSize: WidgetStateProperty.all(20),
          backgroundColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) => states.contains(WidgetState.selected)
                ? AppColors.primaryGreen
                : Colors.transparent,
          ),
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          side: WidgetStateProperty.all(BorderSide.none),
          shape: WidgetStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          )),
          padding: WidgetStateProperty.all(
            const EdgeInsets.fromLTRB(12, 16, 16, 16),
          ),
        ),
        segments: <ButtonSegment<ThemeMode>>[
          _buildSegment(
              ThemeMode.system, context.l10n.system, Icons.settings_suggest),
          _buildSegment(ThemeMode.light, context.l10n.light, Icons.light_mode),
          _buildSegment(ThemeMode.dark, context.l10n.dark, Icons.dark_mode),
        ],
        selected: <ThemeMode>{selectedMode},
        onSelectionChanged: (Set<ThemeMode> newSelection) {
          onModeChanged(newSelection.first);
        },
      ),
    );
  }

  ButtonSegment<ThemeMode> _buildSegment(
      ThemeMode mode, String label, IconData iconData) {
    return ButtonSegment<ThemeMode>(
      value: mode,
      label: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(label, style: AppTextStyle.primary14r),
      ),
      icon: Icon(iconData, size: 20),
    );
  }
}
