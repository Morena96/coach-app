import 'package:domain/features/shared/utilities/result.dart';
import 'package:domain/features/shared/value_objects/filter_criteria.dart';
import 'package:domain/features/shared/value_objects/sort_criteria.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:riverpod/riverpod.dart';

import 'package:coach_app/shared/view_models/paginated_view_model.dart';

class Item {
  final int id;
  Item(this.id);
}

class ItemView {
  final int id;
  ItemView(this.id);
}

class TestPaginatedViewModel extends PaginatedViewModel<ItemView, Item> {
  TestPaginatedViewModel({
    super.pageSize,
    this.mockFetchItems,
    this.mockDeleteItemFromService,
  });

  final Future<Result<List<Item>>> Function(int pageKey, int pageSize)?
      mockFetchItems;
  final Future<Result<void>> Function(ItemView item)? mockDeleteItemFromService;

  @override
  Future<Result<List<Item>>> fetchItems(
    int pageKey,
    int pageSize, {
    FilterCriteria? filterCriteria,
    SortCriteria? sortCriteria,
  }) async {
    if (mockFetchItems != null) {
      return mockFetchItems!(pageKey, pageSize);
    }
    return Result.success(
        List.generate(pageSize, (index) => Item(pageKey * pageSize + index)));
  }

  @override
  ItemView convertItem(Item item) {
    return ItemView(item.id);
  }

  @override
  Future<Result<void>> deleteItemFromService(ItemView item) async {
    if (mockDeleteItemFromService != null) {
      return mockDeleteItemFromService!(item);
    }
    return Result.success(null);
  }
}

@GenerateMocks([])
void main() {
  group('PaginatedViewModel', () {
    late TestPaginatedViewModel viewModel;

    setUp(() {
      viewModel = TestPaginatedViewModel();
    });

    test('fetches first page on initialization', () async {
      await Future.delayed(Duration.zero); // Allow microtask to complete
      expect(viewModel.pagingController.itemList, isNotNull);
      expect(viewModel.pagingController.itemList!.length, 50);
      expect(viewModel.state, isA<AsyncData>());
    });

    test('fetches next page when requested', () async {
      await Future.delayed(Duration.zero); // Allow first page to load
      viewModel.pagingController.notifyPageRequestListeners(1);
      await Future.delayed(Duration.zero); // Allow second page to load
      expect(viewModel.pagingController.itemList!.length, 100);
      expect(viewModel.state, isA<AsyncData>());
    });

    test('handles last page correctly', () async {
      viewModel = TestPaginatedViewModel(
        pageSize: 30,
        mockFetchItems: (pageKey, pageSize) async {
          if (pageKey == 0) {
            return Result.success(List.generate(30, (index) => Item(index)));
          } else {
            return Result.success(
                List.generate(10, (index) => Item(30 + index)));
          }
        },
      );
      await Future.delayed(Duration.zero); // Allow first page to load
      expect(viewModel.pagingController.itemList!.length, 30);
      expect(viewModel.pagingController.nextPageKey, 1);

      viewModel.pagingController.notifyPageRequestListeners(1);
      await Future.delayed(Duration.zero); // Allow second page to load
      expect(viewModel.pagingController.itemList!.length, 40);
      expect(
          viewModel.pagingController.nextPageKey, null); // Indicates last page
    });

    test('handles errors during fetch', () async {
      viewModel = TestPaginatedViewModel(
        mockFetchItems: (_, __) async => Result.failure('Fetch error'),
      );
      viewModel.refresh();
      await Future.delayed(Duration.zero); // Allow error to propagate
      expect(viewModel.state, isA<AsyncError>());
      expect(viewModel.pagingController.error, isNotNull);
    });

    test('deletes item successfully', () async {
      await Future.delayed(Duration.zero); // Allow first page to load
      final itemToDelete = viewModel.pagingController.itemList![0];
      final result = await viewModel.deleteItem(itemToDelete);
      expect(result, true);
      expect(
          viewModel.pagingController.itemList!.contains(itemToDelete), false);
      expect(viewModel.state, isA<AsyncData>());
    });

    test('handles errors during delete', () async {
      viewModel = TestPaginatedViewModel(
        mockDeleteItemFromService: (_) async => Result.failure('Delete error'),
      );
      await Future.delayed(Duration.zero); // Allow first page to load
      final itemToDelete = viewModel.pagingController.itemList![0];
      final result = await viewModel.deleteItem(itemToDelete);
      expect(result, false);
      expect(viewModel.pagingController.itemList!.contains(itemToDelete), true);
      expect(viewModel.state, isA<AsyncError>());
    });
    test('refresh resets paging controller and fetches first page', () async {
      await Future.delayed(Duration.zero); // Allow first page to load
      expect(viewModel.pagingController.itemList, isNotNull);
      expect(viewModel.pagingController.itemList!.length, 50);

      viewModel.refresh();

      // Wait for a longer period to ensure refresh has time to complete
      await Future.delayed(const Duration(milliseconds: 200));

      // Check the state of the viewModel after refresh
      expect(viewModel.state, isA<AsyncData>(),
          reason: 'ViewModel should be in AsyncData state after refresh');

      // Check if the paging controller has been reset
      expect(viewModel.pagingController.nextPageKey, 0,
          reason: 'nextPageKey should be reset to 0 after refresh');
    });

    test('dispose cleans up resources', () {
      expect(() => viewModel.dispose(), returnsNormally);
      expect(viewModel.pagingController.hasListeners, false);
    });

    test('convertItem works correctly', () {
      final item = Item(1);
      final convertedItem = viewModel.convertItem(item);
      expect(convertedItem, isA<ItemView>());
      expect(convertedItem.id, 1);
    });

    test('fetchItems uses mockFetchItems when provided', () async {
      final mockItems = [Item(1), Item(2), Item(3)];
      viewModel = TestPaginatedViewModel(
        mockFetchItems: (_, __) async => Result.success(mockItems),
      );

      await Future.delayed(Duration.zero); // Allow first page to load

      expect(viewModel.pagingController.itemList!.length, 3);
      expect(viewModel.pagingController.itemList!.map((item) => item.id),
          equals(mockItems.map((item) => item.id)));
    });

    test('deleteItemFromService uses mockDeleteItemFromService when provided',
        () async {
      bool deleteMethodCalled = false;
      viewModel = TestPaginatedViewModel(
        mockDeleteItemFromService: (_) async {
          deleteMethodCalled = true;
          return Result.success(null);
        },
      );

      await Future.delayed(Duration.zero); // Allow first page to load
      final itemToDelete = viewModel.pagingController.itemList![0];
      await viewModel.deleteItem(itemToDelete);

      expect(deleteMethodCalled, true);
    });
  });
}
