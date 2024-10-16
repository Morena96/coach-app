import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'package:coach_app/core/theme/app_colors.dart';
import 'package:coach_app/core/theme/app_text_style.dart';
import 'package:coach_app/l10n.dart';
import 'package:coach_app/shared/view_models/paginated_view_model.dart';

/// A generic autocomplete selector widget that works with paginated data.
class PaginatedAutocompleteSelector<T extends Object>
    extends ConsumerStatefulWidget {
  /// Callback function when an item is selected.
  final void Function(T) onItemSelected;

  /// Provider that supplies the paginated view model.
  final AutoDisposeStateNotifierProvider<PaginatedViewModel<T, dynamic>,
      AsyncValue<void>> viewModelProvider;

  /// Function to convert an item to its display string.
  final String Function(T) labelBuilder;

  /// Function to filter items based on the input text.
  final void Function(String) onSearch;

  /// Hint text for the input field.
  final String? hintText;

  /// Widget to build each item in the dropdown.
  final Widget Function(BuildContext, T) itemBuilder;

  /// List of already selected items to be excluded from the dropdown.
  final List<T> selectedItems;

  /// Whether to allow multiple selections or just a single selection.
  final bool multiSelect;

  const PaginatedAutocompleteSelector({
    super.key,
    required this.onItemSelected,
    required this.viewModelProvider,
    required this.labelBuilder,
    required this.onSearch,
    required this.selectedItems,
    required this.itemBuilder,
    this.hintText,
    this.multiSelect = true,
  });

  @override
  ConsumerState<PaginatedAutocompleteSelector<T>> createState() =>
      _PaginatedAutocompleteSelectorState<T>();
}

class _PaginatedAutocompleteSelectorState<T extends Object>
    extends ConsumerState<PaginatedAutocompleteSelector<T>> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  T? _selectedItem;
  Timer? _debounce;
  bool _isDropdownActive = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    _focusNode.addListener(_focusListener);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.removeListener(_focusListener);
    _focusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _clearField() {
    _controller.clear();
    setState(() {
      _selectedItem = null;
      _isDropdownActive = true;
    });
    _focusNode.requestFocus();
  }

  void _onItemSelected(T item) {
    widget.onItemSelected(item);
    setState(() {
      _selectedItem = item;
      _isDropdownActive = false;
    });
    _focusNode.unfocus();
  }

  void _focusListener() {
    setState(() {
      _isDropdownActive = _focusNode.hasFocus;
    });
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      widget.onSearch(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(widget.viewModelProvider.notifier);

    return LayoutBuilder(
      builder: (context, constraints) {
        return RawAutocomplete<T>(
          textEditingController: _controller,
          focusNode: _focusNode,
          optionsBuilder: (TextEditingValue textEditingValue) {
            _onSearchChanged(textEditingValue.text);
            return viewModel.pagingController.itemList ?? [];
          },
          displayStringForOption: widget.labelBuilder,
          fieldViewBuilder: (BuildContext context,
              TextEditingController controller,
              FocusNode focusNode,
              VoidCallback onFieldSubmitted) {
            return _isDropdownActive ||
                    _selectedItem == null ||
                    widget.multiSelect
                ? SizedBox(
                    height: 55,
                    child: TextFormField(
                      controller: controller,
                      focusNode: focusNode,
                      style: AppTextStyle.primary16r
                          .copyWith(color: AppColors.black),
                      decoration: InputDecoration(
                        hintText: widget.hintText ?? context.l10n.selectAnItem,
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: AppColors.additionalBlack,
                            size: 20,
                          ),
                          onPressed: () => focusNode.requestFocus(),
                        ),
                      ),
                      onChanged: _onSearchChanged,
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: _clearField,
                            child: widget.itemBuilder(context, _selectedItem!),
                          ),
                        ),
                        const Icon(
                          Icons.arrow_drop_down,
                          color: AppColors.additionalBlack,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                  );
          },
          optionsViewBuilder: (BuildContext context,
              AutocompleteOnSelected<T> onSelected, Iterable<T> options) {
            return Container(
              padding: const EdgeInsets.only(top: 8),
              alignment: Alignment.topLeft,
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: 200,
                    maxWidth: constraints.maxWidth,
                  ),
                  child: PagedListView<int, T>(
                    pagingController: viewModel.pagingController,
                    builderDelegate: PagedChildBuilderDelegate<T>(
                      itemBuilder: (context, item, index) {
                        if (widget.selectedItems.contains(item)) {
                          return const SizedBox.shrink();
                        }
                        return InkWell(
                          onTap: () => _onItemSelected(item),
                          child: widget.itemBuilder(context, item),
                        );
                      },
                      noItemsFoundIndicatorBuilder: (_) => Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          context.l10n.noItemsFound,
                          style: AppTextStyle.primary14r,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
