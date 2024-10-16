import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import "package:coach_app/core/widgets/screens/error_screen.dart";
import 'package:coach_app/features/sessions/presentation/models/session_view.dart';
import 'package:coach_app/features/sessions/presentation/providers/sessions_view_model_provider.dart';
import 'package:coach_app/features/sessions/presentation/widgets/session_table_header.dart';
import 'package:coach_app/features/sessions/presentation/widgets/session_table_item.dart';
import 'package:coach_app/l10n.dart';
import 'package:coach_app/shared/extensions/context.dart';

/// Displays a paginated list of sessions in a table format.
///
/// This widget uses [PagedListView] to efficiently load and display sessions.
/// It includes pull-to-refresh functionality and handles various states such as
/// loading, errors, and empty list scenarios.
class SessionListView extends ConsumerWidget {
  /// Creates an [SessionListView].
  const SessionListView({
    super.key,
    this.groupId,
  });

  /// The ID of the group to filter sessions by.
  final String? groupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(sessionsViewModelProvider(groupId).notifier);

    // reusable divider
    final divider =
        Container(height: 1, color: context.color.onSurface.withOpacity(.08));

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: context.color.tertiary,
      ),
      child: Column(
        children: [
          const SessionTableHeader(),
          divider,
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                // Refresh the list when pulled down
                final viewModel =
                    ref.read(sessionsViewModelProvider(groupId).notifier);
                viewModel.refresh();
                return Future.delayed(const Duration(seconds: 1));
              },
              child: PagedListView<int, SessionView>.separated(
                separatorBuilder: (_, __) => divider,
                physics: const AlwaysScrollableScrollPhysics(),
                pagingController: viewModel.pagingController,
                builderDelegate: PagedChildBuilderDelegate<SessionView>(
                  itemBuilder: (context, session, index) =>
                      SessionTableItem(session: session, groupId: groupId),
                  firstPageErrorIndicatorBuilder: (context) => ErrorScreen(
                    error: context.l10n.errorOnLoadingSessions,
                    onRetry: () => viewModel.pagingController.refresh(),
                  ),
                  newPageErrorIndicatorBuilder: (context) => ErrorScreen(
                    error: context.l10n.errorOnLoadingMoreSessions,
                    onRetry: () =>
                        viewModel.pagingController.retryLastFailedRequest(),
                  ),
                  noItemsFoundIndicatorBuilder: (context) => Center(
                    child: Text(context.l10n.noSessions),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
