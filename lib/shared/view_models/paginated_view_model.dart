import 'package:domain/features/shared/utilities/result.dart';
import 'package:domain/features/shared/value_objects/filter_criteria.dart';
import 'package:domain/features/shared/value_objects/sort_criteria.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

/// Abstract class for managing paginated data in view models.
abstract class PaginatedViewModel<T, S>
    extends StateNotifier<AsyncValue<void>> {
  FilterCriteria? _filterCriteria;
  SortCriteria? _sortCriteria;

  late final PagingController<int, T> pagingController;
  final int _pageSize;

  /// Notifier for filter state changes
  final ValueNotifier<bool> _hasActiveFiltersNotifier = ValueNotifier(false);

  /// Getter for the filter state notifier
  ValueNotifier<bool> get hasActiveFiltersNotifier => _hasActiveFiltersNotifier;

  PaginatedViewModel({int pageSize = 50, bool setupListener = true})
      : _pageSize = pageSize,
        super(const AsyncValue.loading()) {
    pagingController = PagingController<int, T>(firstPageKey: 0);
    if (setupListener) setUpListener();
  }

  setUpListener() {
    pagingController.addPageRequestListener(_fetchPage);
  }

  /// Applies filter and sort criteria, then refreshes the data.
  void applyCriteria(
      {FilterCriteria? filterCriteria,
      SortCriteria? sortCriteria,
      bool reload = true}) {
    _filterCriteria = filterCriteria;
    _sortCriteria = sortCriteria;
    if (reload) {
      pagingController.itemList?.clear();
      _fetchPage(0);
    }
  }

  Future<Result<List<S>>> fetchItems(
    int pageKey,
    int pageSize, {
    FilterCriteria? filterCriteria,
    SortCriteria? sortCriteria,
  });

  T convertItem(S item);

  Future<Result<void>> deleteItemFromService(T item);

  Future<void> _fetchPage(int pageKey) async {
    try {
      final result = await fetchItems(pageKey, _pageSize,
          filterCriteria: _filterCriteria, sortCriteria: _sortCriteria);
      if (result.isSuccess) {
        final items = result.value!;
        final convertedItems = items.map(convertItem).toList();
        final isLastPage = convertedItems.length < _pageSize;

        if (pageKey == 0) pagingController.itemList?.clear();
        if (isLastPage) {
          pagingController.appendLastPage(convertedItems);
        } else {
          final nextPageKey = pageKey + 1;
          pagingController.appendPage(convertedItems, nextPageKey);
        }
        state = const AsyncValue.data(null);
      } else {
        pagingController.error = result.error;
        state = AsyncValue.error(
            result.error ?? 'Unknown error', StackTrace.current);
      }
    } catch (error, stackTrace) {
      pagingController.error = error;
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<bool> deleteItem(T item) async {
    final result = await deleteItemFromService(item);
    if (result.isSuccess) {
      pagingController.itemList?.removeWhere((i) => i == item);
      pagingController.notifyListeners();
      state = const AsyncValue.data(null);
      return true;
    } else {
      state =
          AsyncValue.error(result.error ?? 'Unknown error', StackTrace.current);
      return false;
    }
  }

  void updateHasActiveFilters({required bool hasActiveFilters}) {
    _hasActiveFiltersNotifier.value = hasActiveFilters;
  }

  void refresh() {
    pagingController.refresh();
  }

  @override
  void dispose() {
    pagingController.dispose();
    super.dispose();
  }
}
