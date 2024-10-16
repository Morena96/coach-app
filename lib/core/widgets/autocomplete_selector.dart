import 'package:coach_app/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:coach_app/core/theme/app_colors.dart';
import 'package:coach_app/core/theme/app_text_style.dart';
import 'package:coach_app/shared/extensions/context.dart';

/// A generic autocomplete selector widget that can be used with various types of data.
/// Supports both single and multi-select modes.
class AutocompleteSelector<T extends Object> extends ConsumerStatefulWidget {
  /// Callback function when an item is selected.
  final void Function(T) onItemSelected;

  /// Provider that supplies the list of items.
  final ProviderListenable<AsyncValue<List<T>>> itemsProvider;

  /// Function to convert an item to its display string.
  final String Function(T) labelBuilder;

  /// Function to filter items based on the input text.
  final bool Function(T, String) filterOption;

  /// Hint text for the input field.
  final String? hintText;

  /// Widget to build each item in the dropdown.
  final Widget Function(BuildContext, T)? itemBuilder;

  /// List of already selected items to be excluded from the dropdown.
  final List<T> selectedItems;

  /// Whether to allow multiple selections or just a single selection.
  final bool multiSelect;

  const AutocompleteSelector({
    super.key,
    required this.onItemSelected,
    required this.itemsProvider,
    required this.labelBuilder,
    required this.filterOption,
    required this.selectedItems,
    this.hintText,
    this.itemBuilder,
    this.multiSelect = true,
  });

  @override
  ConsumerState<AutocompleteSelector<T>> createState() =>
      _AutocompleteSelectorState<T>();
}

class _AutocompleteSelectorState<T extends Object>
    extends ConsumerState<AutocompleteSelector<T>> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  T? _selectedItem;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    if (!widget.multiSelect) {
      _focusNode.addListener(_focusListener);
      if (widget.selectedItems.isNotEmpty) {
        _selectedItem = widget.selectedItems.first;
        _controller.text = widget.labelBuilder(_selectedItem!);
      }
    }
  }

  @override
  void didUpdateWidget(covariant AutocompleteSelector<T> oldWidget) {
    if (oldWidget.selectedItems.length == widget.selectedItems.length) return;

    if (!widget.multiSelect && widget.selectedItems.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _selectedItem = widget.selectedItems.first;
        _controller.text = widget.labelBuilder(_selectedItem!);
      });
    }

    super.didUpdateWidget(oldWidget);
  }

  void _clearField() {
    _controller.clear();
    setState(() => _selectedItem = null);
  }

  void _onItemSelected(T item) {
    widget.onItemSelected(item);
    _controller.text = widget.labelBuilder(item);
    _focusNode.unfocus();
    if (!widget.multiSelect) {
      setState(() => _selectedItem = item);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    if (!widget.multiSelect) _focusNode.removeListener(_focusListener);
    _focusNode.dispose();
    super.dispose();
  }

  void _focusListener() {
    if (_focusNode.hasFocus) {
      _controller.clear();
    } else {
      if (_selectedItem != null) {
        _controller.text = widget.labelBuilder(_selectedItem!);
      } else {
        _controller.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemsState = ref.watch(widget.itemsProvider);

    return LayoutBuilder(builder: (context, constraints) {
      return RawAutocomplete<T>(
        textEditingController: _controller,
        focusNode: _focusNode,
        optionsBuilder: (TextEditingValue textEditingValue) => itemsState.when(
          data: (items) {
            final availableItems =
                items.where((item) => !widget.selectedItems.contains(item));
            if (textEditingValue.text.isEmpty) return availableItems;
            return availableItems.where(
                (item) => widget.filterOption(item, textEditingValue.text));
          },
          loading: () => [],
          error: (_, __) => [],
        ),
        displayStringForOption: widget.labelBuilder,
        fieldViewBuilder: (BuildContext context,
            TextEditingController controller,
            FocusNode focusNode,
            VoidCallback onFieldSubmitted) {
          return ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, textEditingValue, child) {
              return TextFormField(
                controller: controller,
                focusNode: focusNode,
                style: AppTextStyle.primary16r.copyWith(color: AppColors.black),
                decoration: InputDecoration(
                  hintText: widget.hintText ?? context.l10n.selectAnItem,
                  suffixIcon: textEditingValue.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(
                            Icons.clear,
                            color: AppColors.additionalBlack,
                            size: 20,
                          ),
                          onPressed: () {
                            _clearField();
                            focusNode.unfocus();
                          },
                        )
                      : null,
                ),
              );
            },
          );
        },
        optionsViewBuilder: (BuildContext context,
            AutocompleteOnSelected<T> onSelected, Iterable<T> options) {
          if (options.isEmpty) return const SizedBox.shrink();
          return Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.only(top: 8),
            child: Material(
              borderRadius: BorderRadius.circular(8.0),
              color: context.color.tertiary,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: 240,
                  maxWidth: constraints.maxWidth,
                ),
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: options.length,
                  separatorBuilder: (_, __) => Container(
                      height: .5,
                      color: context.color.onTertiary.withOpacity(.5)),
                  itemBuilder: (BuildContext context, int index) {
                    final T option = options.elementAt(index);
                    return InkWell(
                      onTap: () => _onItemSelected(option),
                      child: widget.itemBuilder?.call(context, option) ??
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12, 16, 12, 12),
                            child: Text(
                              widget.labelBuilder(option),
                              style: AppTextStyle.primary14r,
                            ),
                          ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      );
    });
  }
}
