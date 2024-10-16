import 'package:coach_app/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import "package:coach_app/core/widgets/screens/error_screen.dart";
import 'package:coach_app/features/athletes/presentation/models/group_view.dart';
import 'package:coach_app/features/athletes/presentation/providers/groups_view_model_provider.dart';
import 'package:coach_app/features/athletes/presentation/widgets/group_table_item.dart';
import 'package:coach_app/shared/constants/app_constants.dart';

/// A grid view that displays a paginated list of groups.
///
/// This widget uses [PagedGridView] to efficiently load and display groups.
/// It adapts its layout based on the screen size, showing 1, 2, or 3 columns
/// depending on the available width. It also includes pull-to-refresh functionality
/// and error handling.
class GroupsGridView extends ConsumerWidget {
  /// Creates a [GroupsGridView].
  const GroupsGridView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(groupsViewModelProvider.notifier);

    return LayoutBuilder(builder: (context, constraints) {
      /// Determine the number of columns based on screen width
      final crossAxisCount =
          constraints.maxWidth > AppConstants.desktopBreakpoint ? 3 : 2;

      return RefreshIndicator(
        onRefresh: () async {
          final viewModel = ref.read(groupsViewModelProvider.notifier);
          viewModel.refresh();
          return Future.delayed(const Duration(seconds: 1));
        },
        child: constraints.maxWidth < AppConstants.mobileBreakpoint
            ? PagedListView<int, GroupView>.separated(
                pagingController: viewModel.pagingController,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                builderDelegate: PagedChildBuilderDelegate<GroupView>(
                  itemBuilder: (context, group, index) =>
                      GroupTableItem(group: group),
                  firstPageErrorIndicatorBuilder: (context) => ErrorScreen(
                    error: context.l10n.errorLoadingGroups,
                    onRetry: () => viewModel.pagingController.refresh(),
                  ),
                  newPageErrorIndicatorBuilder: (context) => ErrorScreen(
                    error: context.l10n.errorLoadingNewGroups,
                    onRetry: () =>
                        viewModel.pagingController.retryLastFailedRequest(),
                  ),
                  noItemsFoundIndicatorBuilder: (context) =>
                      Center(child: Text(context.l10n.noGroups)),
                ),
              )
            : PagedGridView<int, GroupView>(
                physics: const AlwaysScrollableScrollPhysics(),
                pagingController: viewModel.pagingController,
                builderDelegate: PagedChildBuilderDelegate<GroupView>(
                  itemBuilder: (context, group, index) =>
                      GroupTableItem(group: group),
                  firstPageErrorIndicatorBuilder: (context) => ErrorScreen(
                    error: context.l10n.errorLoadingGroups,
                    onRetry: () => viewModel.pagingController.refresh(),
                  ),
                  newPageErrorIndicatorBuilder: (context) => ErrorScreen(
                    error: context.l10n.errorLoadingNewGroups,
                    onRetry: () =>
                        viewModel.pagingController.retryLastFailedRequest(),
                  ),
                  noItemsFoundIndicatorBuilder: (context) => Center(
                    child: Text(context.l10n.noGroups),
                  ),
                ),
                showNewPageProgressIndicatorAsGridChild: false,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisExtent: 172,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                ),
              ),
      );
    });
  }
}
