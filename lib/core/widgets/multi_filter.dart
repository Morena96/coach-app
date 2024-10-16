import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'package:coach_app/core/theme/app_colors.dart';
import 'package:coach_app/core/theme/app_text_style.dart';
import 'package:coach_app/core/widgets/app_divider.dart';
import 'package:coach_app/core/widgets/app_search_field.dart';
import 'package:coach_app/l10n.dart';
import 'package:coach_app/shared/extensions/context.dart';
import 'package:coach_app/shared/view_models/paginated_view_model.dart';

/// A widget that displays multiple filter groups and allows users to select options.
///
/// Example usage:
/// ```dart
/// MultiFilter(
///   filters: [
///     MultiFilterGroup(
///       groupId: 'category',
///       groupName: 'Categories',
///       options: [FilterOption(id: '1', name: 'Electronics'), ...],
///     ),
///     // ... more filter groups
///   ],
///   onApply: (selectedFilters) {
///     // Handle applied filters
///   },
///   onClear: () {
///     // Handle clearing filters
///   },
/// )
/// ```
class MultiFilter extends StatefulWidget {
  const MultiFilter({
    super.key,
    required this.filters,
    required this.onApply,
    required this.onClear,
    this.width,
  });

  /// The list of filter groups to display.
  final List<MultiFilterGroup> filters;

  /// Callback function called when filters are applied.
  ///
  /// The parameter is a map where keys are group IDs and values are lists of selected FilterOptions.
  final Function(Map<String, List<FilterOption>>) onApply;

  /// Callback function called when filters are cleared.
  final VoidCallback onClear;

  /// Optional width for the filter widget.
  final double? width;

  @override
  State<MultiFilter> createState() => _MultiFilterState();
}

class _MultiFilterState extends State<MultiFilter> {
  final _overlayController = OverlayPortalController();
  final LayerLink _layerLink = LayerLink();
  String? _expandedGroupId;

  final _selectedOptions = ValueNotifier<Map<String, List<FilterOption>>>({});
  late Map<String, List<FilterOption>> _previouslySelectedOptions;

  @override
  void initState() {
    super.initState();
    _initializeSelectedOptions();
  }

  void _initializeSelectedOptions() {
    for (var filter in widget.filters) {
      _selectedOptions.value[filter.groupId] =
          List.from(filter.selectedOptions);
    }
    _previouslySelectedOptions = _deepCopy(_selectedOptions.value);
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).size.width < 600
        ? GestureDetector(
            onTap: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: context.color.tertiary,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              builder: (context) => _MultiFilterMobile(
                filters: widget.filters,
                expandedGroupId: _expandedGroupId,
                onExpansionChanged: (expanded, filter) => setState(
                  () => _expandedGroupId = expanded ? filter.groupId : null,
                ),
                selectedOptions: _selectedOptions,
                apply: _applyFilters,
                clear: _clearFilters,
              ),
            ),
            child: Container(
              width: 42,
              height: 42,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.color.tertiary,
                borderRadius: BorderRadius.circular(10),
                border:
                    Border.all(color: context.color.onSurface.withOpacity(.5)),
              ),
              child: SvgPicture.asset('assets/icons/filter.svg',
                  colorFilter: ColorFilter.mode(
                      context.color.onTertiary, BlendMode.srcIn)),
            ),
          )
        : _MultiFilterDesktop(
            layerLink: _layerLink,
            overlayPortalController: _overlayController,
            close: _close,
            filters: widget.filters,
            open: _openOverlay,
            selectedOptions: _selectedOptions,
            expandedGroupId: _expandedGroupId,
            onExpansionChanged: (expanded, filter) => setState(
              () => _expandedGroupId = expanded ? filter.groupId : null,
            ),
            apply: _applyFilters,
            clear: _clearFilters,
          );
  }

  void _clearFilters() {
    setState(() {
      for (var group in _selectedOptions.value.keys) {
        _selectedOptions.value[group] = [];
      }
      _selectedOptions.value = Map.from(_selectedOptions.value);
    });
    widget.onClear();
    _close(reset: false);
  }

  void _openOverlay() {
    _previouslySelectedOptions = _deepCopy(_selectedOptions.value);
    _overlayController.show();
  }

  void _close({reset = true}) {
    if (reset) {
      setState(() {
        _selectedOptions.value = _deepCopy(_previouslySelectedOptions);
      });
    }
    if (context.isDesktop) {
      _overlayController.hide();
    } else {
      Navigator.of(context).pop();
    }
  }

  void _applyFilters() {
    _previouslySelectedOptions = _deepCopy(_selectedOptions.value);
    widget.onApply(_selectedOptions.value);
    _close(reset: false);
  }

  Map<String, List<FilterOption>> _deepCopy(
      Map<String, List<FilterOption>> original) {
    return original.map((key, value) => MapEntry(key, List.from(value)));
  }
}

/// Desktop version of the MultiFilter widget.
class _MultiFilterDesktop extends StatelessWidget {
  const _MultiFilterDesktop({
    required this.layerLink,
    required this.overlayPortalController,
    required this.close,
    required this.filters,
    required this.open,
    required this.selectedOptions,
    required this.expandedGroupId,
    required this.onExpansionChanged,
    required this.apply,
    required this.clear,
  });
  final LayerLink layerLink;
  final OverlayPortalController overlayPortalController;
  final void Function() close;
  final void Function() open;
  final List<MultiFilterGroup> filters;
  final ValueNotifier<Map<String, List<FilterOption>>> selectedOptions;
  final String? expandedGroupId;
  final void Function(bool, MultiFilterGroup) onExpansionChanged;
  final VoidCallback apply, clear;

  bool _anyFilterSelected(Map<String, List<FilterOption>> selectedOptions) {
    return selectedOptions.values.any((group) => group.isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).colorScheme;
    return SizedBox(
      width: 320,
      child: CompositedTransformTarget(
        link: layerLink,
        child: OverlayPortal(
          controller: overlayPortalController,
          overlayChildBuilder: (context) => Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  onTap: close,
                  child: Container(color: Colors.transparent),
                ),
              ),
              CompositedTransformFollower(
                link: layerLink,
                targetAnchor: Alignment.bottomLeft,
                followerAnchor: Alignment.topLeft,
                offset: const Offset(0, 12),
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    width: 320,
                    constraints: const BoxConstraints(maxHeight: 400),
                    decoration: BoxDecoration(
                      color: context.color.tertiary,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: context.color.onSurface.withOpacity(.14),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Flexible(
                          child: SingleChildScrollView(
                            child: Column(
                              children: filters
                                  .map((filter) => _MultiFilterGroupTile(
                                        filter: filter,
                                        expandedGroupId: expandedGroupId,
                                        onExpansionChanged: onExpansionChanged,
                                        selectedOptionsNotifier:
                                            selectedOptions,
                                      ))
                                  .toList(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _MultiFilterButtons(apply: apply, clear: clear),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          child: GestureDetector(
            onTap: open,
            child: Container(
              constraints: const BoxConstraints(maxHeight: 400),
              padding: const EdgeInsets.fromLTRB(16, 3, 3, 3),
              decoration: BoxDecoration(
                border:
                    Border.all(color: context.color.onSurface.withOpacity(.5)),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: ValueListenableBuilder(
                          valueListenable: selectedOptions,
                          builder: (context, selectedOptions, _) {
                            final anySelected =
                                _anyFilterSelected(selectedOptions);
                            return Text(
                              !anySelected
                                  ? 'Filters'
                                  : selectedOptions.values
                                      .where((group) => group.isNotEmpty)
                                      .map((group) => group
                                          .map((option) => option.name)
                                          .join(', '))
                                      .join(', '),
                              style: AppTextStyle.secondary16r.copyWith(
                                  color: !anySelected
                                      ? themeColor.onTertiary.withOpacity(.5)
                                      : themeColor.onSurface),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            );
                          }),
                    ),
                  ),
                  const SizedBox(width: 16),
                  SvgPicture.asset('assets/icons/filter-circle.svg')
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Mobile version of the MultiFilter widget.
class _MultiFilterMobile extends StatelessWidget {
  const _MultiFilterMobile({
    required this.filters,
    required this.expandedGroupId,
    required this.onExpansionChanged,
    required this.selectedOptions,
    required this.apply,
    required this.clear,
  });
  final List<MultiFilterGroup> filters;
  final String? expandedGroupId;
  final void Function(bool, MultiFilterGroup) onExpansionChanged;
  final ValueNotifier<Map<String, List<FilterOption>>> selectedOptions;
  final VoidCallback apply, clear;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      expand: false,
      builder: (_, scrollController) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 16, 6),
              child: Row(
                children: [
                  Expanded(
                    child: Text(context.l10n.filters,
                        style: AppTextStyle.primary18b),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const AppDivider(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: filters
                      .map((filter) => _MultiFilterGroupTile(
                            filter: filter,
                            expandedGroupId: expandedGroupId,
                            onExpansionChanged: onExpansionChanged,
                            selectedOptionsNotifier: selectedOptions,
                          ))
                      .toList(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 20),
              child: _MultiFilterButtons(apply: apply, clear: clear),
            ),
          ],
        );
      },
    );
  }
}

/// Expandable tile for a single filter group.
class _MultiFilterGroupTile extends StatelessWidget {
  const _MultiFilterGroupTile({
    required this.filter,
    required this.expandedGroupId,
    required this.onExpansionChanged,
    required this.selectedOptionsNotifier,
  });
  final MultiFilterGroup filter;
  final String? expandedGroupId;
  final void Function(bool, MultiFilterGroup) onExpansionChanged;
  final ValueNotifier<Map<String, List<FilterOption>>> selectedOptionsNotifier;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExpansionTile(
          iconColor: context.color.onTertiary,
          collapsedIconColor: context.color.onTertiary,
          initiallyExpanded: filter.groupId == expandedGroupId,
          onExpansionChanged: (expanded) =>
              onExpansionChanged(expanded, filter),
          title: Text(
            filter.groupName,
            style: TextStyle(color: context.color.onSurface, fontSize: 16),
          ),
          tilePadding: const EdgeInsets.symmetric(horizontal: 16),
          childrenPadding: EdgeInsets.zero,
          children: [
            Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AppSearchField(
                initialQuery: filter.initialSearch(),
                width: context.isDesktop ? null : double.infinity,
                onSearchChanged: filter.onSearchChanged,
              ),
            ),
            ValueListenableBuilder(
              valueListenable: selectedOptionsNotifier,
              builder: (context, selectedOptions, _) {
                return SizedBox(
                  height: context.isDesktop ? 200 : 280,
                  child: PagedListView<int, dynamic>(
                    pagingController: filter.viewModelProvider.pagingController,
                    builderDelegate: PagedChildBuilderDelegate<dynamic>(
                      itemBuilder: (context, item, index) {
                        return CheckboxListTile(
                          title: Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(item.name,
                                style: const TextStyle(fontSize: 16)),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 10),
                          value: selectedOptions[filter.groupId]
                                  ?.contains(filter.toFilterOption(item)) ??
                              false,
                          onChanged: (bool? value) {
                            final filterOption = filter.toFilterOption(item);

                            if (value!) {
                              selectedOptionsNotifier.value[filter.groupId]
                                  ?.add(filterOption);
                            } else {
                              selectedOptionsNotifier.value[filter.groupId]
                                  ?.remove(filterOption);
                            }
                            selectedOptionsNotifier.value =
                                Map.from(selectedOptionsNotifier.value);
                          },
                          activeColor: AppColors.primaryGreen,
                          checkColor: Colors.black,
                          side: BorderSide(color: Colors.grey[200]!),
                          controlAffinity: ListTileControlAffinity.leading,
                          visualDensity: VisualDensity.compact,
                          dense: true,
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
                );
              },
            )
          ],
        ),
        Container(
          height: 1,
          width: double.infinity,
          color: context.color.onSurface.withOpacity(.14),
        )
      ],
    );
  }
}

/// Buttons for applying and clearing filters.
class _MultiFilterButtons extends StatelessWidget {
  const _MultiFilterButtons({required this.apply, required this.clear});
  final VoidCallback apply;
  final VoidCallback clear;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: clear,
              child: Text(
                context.l10n.clearFilters,
                style: AppTextStyle.primary12r,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: apply,
              child: Text(
                context.l10n.applyFilters,
                style: AppTextStyle.primary12r,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Represents a group of filter options with pagination support.
///
/// This class is used to define a filter group for the
/// MultiFilter widget.
class MultiFilterGroup<T> {
  MultiFilterGroup({
    required this.groupName,
    required this.groupId,
    required this.viewModelProvider,
    required this.toFilterOption,
    required this.onSearchChanged,
    required this.initialSearch,
    this.selectedOptions = const [],
  });

  /// The display name of the filter group.
  final String groupName;

  /// The unique identifier for the filter group.
  final String groupId;

  /// Provider that supplies the paginated view model.
  final PaginatedViewModel<T, dynamic> viewModelProvider;

  /// Function to convert a model object to a FilterOption.
  final FilterOption Function(T) toFilterOption;

  /// The list of currently selected option IDs.
  final List<FilterOption> selectedOptions;

  /// Callback function called when the search query changes.
  final void Function(String) onSearchChanged;

  /// Function that returns the initial search query.
  final String Function() initialSearch;
}

/// Represents a single filter option.
class FilterOption extends Equatable {
  /// The display name of the filter option.
  final String name;

  /// The unique identifier for the filter option.
  final String id;

  /// Creates a FilterOption.
  ///
  /// All parameters are required.
  const FilterOption({
    required this.name,
    required this.id,
  });

  @override
  String toString() => name;

  @override
  List<Object?> get props => [id];
}
