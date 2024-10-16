import 'package:coach_app/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';

/// A dropdown widget that adheres to the app's design language.
class AppDropdown<T> extends StatelessWidget {
  /// The currently selected value.
  final T value;

  /// The list of items to display in the dropdown.
  final List<DropdownMenuItem<T>> items;

  /// Callback function when the selected item changes.
  final ValueChanged<T?> onChanged;

  /// The hint text to display when no item is selected.
  final String? hint;

  final Color? backgroundColor;
  final Color? foregroundColor;

  final EdgeInsetsGeometry? padding;

  const AppDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.hint,
    this.backgroundColor,
    this.foregroundColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        filled: true,
        fillColor: backgroundColor ?? Theme.of(context).colorScheme.tertiary,
        contentPadding:
            padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              BorderSide(color: Theme.of(context).colorScheme.onSurface),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          style: AppTextStyle.primary16r.copyWith(color: foregroundColor),
          iconEnabledColor: foregroundColor,
          iconDisabledColor: foregroundColor?.withOpacity(.5),
          iconSize: 20,
          isExpanded: true,
          value: value,
          items: items,
          onChanged: onChanged,
          hint: hint != null
              ? Text(hint!,
                  style: TextStyle(color: foregroundColor?.withOpacity(.5)))
              : null,
          dropdownColor:
              backgroundColor ?? Theme.of(context).colorScheme.tertiary,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
