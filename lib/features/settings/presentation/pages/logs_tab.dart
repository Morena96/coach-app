import 'package:coach_app/core/widgets/screens/error_screen.dart';
import 'package:coach_app/features/settings/presentation/providers/get_all_logs_by_page_use_case_provider.dart';
import 'package:coach_app/l10n.dart';
import 'package:domain/features/logging/entities/log_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class LogsTab extends ConsumerStatefulWidget {
  const LogsTab({super.key});

  @override
  ConsumerState<LogsTab> createState() => _LogsTabState();
}

class _LogsTabState extends ConsumerState<LogsTab> {
  static const _pageSize = 20;
  final PagingController<int, LogEntry> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final useCase = ref.read(getAllLogsByPageUseCaseProvider);
      final newItems = await useCase.execute(pageKey, _pageSize);
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height, // Use full screen height
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => Future.sync(
                    () => _pagingController.refresh(),
              ),
              child: PagedListView<int, LogEntry>(
                pagingController: _pagingController,
                builderDelegate: PagedChildBuilderDelegate<LogEntry>(
                  itemBuilder: (context, item, index) => Container(
                    width: double.infinity,
                    padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                    child: Text(
                      '${item.level.name.toUpperCase()}: ${item.message}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  firstPageErrorIndicatorBuilder: (context) => ErrorScreen(
                    error: context.l10n.errorOnLoadingLogs,
                    onRetry: () => _pagingController.refresh(),
                  ),
                  newPageErrorIndicatorBuilder: (context) => ErrorScreen(
                    error: context.l10n.errorOnLoadingMoreLogs,
                    onRetry: () => _pagingController.retryLastFailedRequest(),
                  ),
                  noItemsFoundIndicatorBuilder: (context) => Center(
                    child: Text(context.l10n.noLogs),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
