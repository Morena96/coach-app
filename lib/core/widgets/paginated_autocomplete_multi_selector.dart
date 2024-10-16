import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'package:coach_app/core/theme/app_colors.dart';
import 'package:coach_app/core/theme/app_text_style.dart';
import 'package:coach_app/l10n.dart';
import 'package:coach_app/shared/view_models/paginated_view_model.dart';

/// A widget that allows multiple selections from a paginated list of items.
class PaginatedAutocompleteMultiSelector<T extends Object>
    extends ConsumerStatefulWidget {
  /// Callback function when items are selected.
  final void Function(List<T>) onItemsSelected;

  /// Provider that supplies the paginated view model.
  final AutoDisposeStateNotifierProvider<PaginatedViewModel<T, dynamic>,
      AsyncValue<void>> viewModelProvider;

  /// Function to convert an item to its display string.
  final String Function(T) labelBuilder;

  /// Function to filter items based on the input text.
  final void Function(String) onSearch;

  /// Hint text for the input field.
  final String hintText;

  /// Widget to build each item in the dropdown.
  final Widget Function(BuildContext, T) itemBuilder;

  /// Initially selected items.
  final List<T> initialSelectedItems;

  /// Label for the positive action button.
  final String? positiveButtonLabel;

  /// Widget to display when no items are found
  final Widget Function(VoidCallback, String)? noItemsFoundWidget;

  const PaginatedAutocompleteMultiSelector({
    super.key,
    required this.onItemsSelected,
    required this.viewModelProvider,
    required this.labelBuilder,
    required this.onSearch,
    required this.itemBuilder,
    required this.hintText,
    this.initialSelectedItems = const [],
    this.positiveButtonLabel,
    this.noItemsFoundWidget,
  });

  @override
  ConsumerState<PaginatedAutocompleteMultiSelector<T>> createState() =>
      _PaginatedAutocompleteMultiSelectorState<T>();
}

class _PaginatedAutocompleteMultiSelectorState<T extends Object>
    extends ConsumerState<PaginatedAutocompleteMultiSelector<T>> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  late List<T> _selectedItems;

  Timer? _debounce;
  bool _isDropdownActive = false;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    _focusNode.addListener(_focusListener);
    _selectedItems = List.from(widget.initialSelectedItems);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.removeListener(_focusListener);
    _focusNode.dispose();
    _debounce?.cancel();
    _overlayEntry?.remove();
    super.dispose();
  }

  void _focusListener() {
    if (_focusNode.hasFocus && !_isDropdownActive) {
      _showOverlay();
    }
  }

  void _showOverlay() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Size size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height + 5.0),
          child: Material(
            borderRadius: BorderRadius.circular(12),
            color: AppColors.white,
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.4,
              ),
              child: Column(
                children: [
                  _buildSelectedItemsList(),
                  Expanded(child: _buildItemList()),
                  _buildActionButtons(),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _isDropdownActive = true);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() => _isDropdownActive = false);
  }

  Widget _buildSelectedItemsList() {
    return SizedBox(
      height: _selectedItems.isNotEmpty ? 50 : 0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _selectedItems.length,
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Chip(
              color: const WidgetStatePropertyAll(AppColors.grey100),
              label: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  widget.labelBuilder(_selectedItems[index]),
                  style: const TextStyle(color: AppColors.black),
                ),
              ),
              onDeleted: () => _toggleItemSelection(_selectedItems[index]),
            ),
          );
        },
      ),
    );
  }

  Widget _buildItemList() {
    return Consumer(
      builder: (context, ref, child) {
        final viewModel = ref.watch(widget.viewModelProvider.notifier);
        return PagedListView<int, T>(
          pagingController: viewModel.pagingController,
          builderDelegate: PagedChildBuilderDelegate<T>(
            itemBuilder: (context, item, index) {
              return CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                value: _selectedItems.contains(item),
                onChanged: (_) => _toggleItemSelection(item),
                side: WidgetStateBorderSide.resolveWith(
                  (states) => const BorderSide(
                      width: 1.0, color: AppColors.additionalBlack),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                title: widget.itemBuilder(context, item),
              );
            },
            noItemsFoundIndicatorBuilder: (_) =>
                widget.noItemsFoundWidget?.call(() {
                  _hideOverlay();
                  _controller.clear();
                }, _controller.text) ??
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    context.l10n.noItemsFound,
                    style: AppTextStyle.secondary14r,
                  ),
                ),
          ),
        );
      },
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: TextButton(
              onPressed: _cancel,
              child: Text(context.l10n.cancel,
                  style: const TextStyle(color: AppColors.black)),
            ),
          ),
          Expanded(
            child: ElevatedButton(
              onPressed: _apply,
              child: Text(widget.positiveButtonLabel ?? context.l10n.save),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleItemSelection(T item) {
    setState(() {
      if (_selectedItems.contains(item)) {
        _selectedItems.remove(item);
      } else {
        _selectedItems.add(item);
      }
    });
    _updateOverlay();
  }

  void _updateOverlay() {
    _overlayEntry?.markNeedsBuild();
  }

  void _cancel() {
    setState(() {
      _selectedItems = List.from(widget.initialSelectedItems);
    });
    _hideOverlay();
  }

  void _apply() {
    widget.onItemsSelected(_selectedItems);
    _controller.clear();
    _hideOverlay();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      widget.onSearch(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextFormField(
        controller: _controller,
        focusNode: _focusNode,
        style: AppTextStyle.primary16r.copyWith(color: AppColors.black),
        decoration: InputDecoration(
          hintText: widget.hintText,
          suffixIcon: IconButton(
            icon: const Icon(Icons.arrow_drop_down),
            onPressed: _isDropdownActive ? _hideOverlay : _showOverlay,
          ),
        ),
        onChanged: _onSearchChanged,
      ),
    );
  }
}
