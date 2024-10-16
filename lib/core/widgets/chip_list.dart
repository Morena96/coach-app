import 'package:coach_app/core/theme/app_text_style.dart';
import 'package:coach_app/shared/extensions/context.dart';
import 'package:flutter/material.dart';

/// A reusable widget for displaying a list of chips.
class ChipList<T> extends StatelessWidget {
  /// The list of items to display as chips.
  final List<T> items;

  /// Function to convert an item to its display string.
  final String Function(T) labelBuilder;

  /// Callback function when a chip is deleted.
  final void Function(T) onDeleted;

  /// Optional custom chip builder for full customization.
  final Widget Function(BuildContext, T)? chipBuilder;

  /// Spacing between chips.
  final double spacing;

  /// Spacing between rows of chips.
  final double runSpacing;

  /// Background color for the chips.
  final Color? chipBackgroundColor;

  /// Border color for the chips.
  final Color? chipBorderColor;

  /// Text style for the chip labels.
  final TextStyle? labelStyle;

  /// Icon for the delete button.
  final Widget? deleteIcon;

  const ChipList({
    super.key,
    required this.items,
    required this.labelBuilder,
    required this.onDeleted,
    this.chipBuilder,
    this.spacing = 12,
    this.runSpacing = 12,
    this.chipBackgroundColor,
    this.chipBorderColor,
    this.labelStyle = AppTextStyle.primary14r,
    this.deleteIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: spacing,
      runSpacing: runSpacing,
      children: items.map((item) {
        if (chipBuilder != null) {
          return chipBuilder!(context, item);
        }
        return Chip(
          label: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              labelBuilder(item),
              style: labelStyle ?? AppTextStyle.primary14r,
            ),
          ),
          deleteIcon: deleteIcon ?? const Icon(Icons.close, size: 18),
          backgroundColor: chipBackgroundColor ?? context.color.tertiary,
          side: BorderSide(
            color: chipBorderColor ?? context.color.onSurface.withOpacity(.14),
          ),
          onDeleted: () => onDeleted(item),
        );
      }).toList(),
    );
  }
}
