import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import "package:coach_app/core/widgets/screens/error_screen.dart";
import 'package:coach_app/features/athletes/presentation/models/athlete_view.dart';
import 'package:coach_app/features/athletes/presentation/providers/athletes_view_model_provider.dart';
import 'package:coach_app/features/athletes/presentation/widgets/athlete_table_header.dart';
import 'package:coach_app/features/athletes/presentation/widgets/athlete_table_item.dart';
import 'package:coach_app/l10n.dart';
import 'package:coach_app/shared/extensions/context.dart';

/// A widget that displays a paginated list of athletes.
///
/// This widget uses [PagedListView] to efficiently load and display large lists of athletes.
/// It includes pull-to-refresh functionality, error handling, and empty state display.
class AthleteListView extends ConsumerWidget {
  /// Creates an [AthleteListView].
  const AthleteListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(athletesViewModelProvider.notifier);

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
          // Header for the athlete table
          const AthleteTableHeader(),
          divider,
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                // Refresh the list when pulled down
                final viewModel = ref.read(athletesViewModelProvider.notifier);
                viewModel.refresh();
                return Future.delayed(const Duration(seconds: 1));
              },
              child: PagedListView<int, AthleteView>.separated(
                separatorBuilder: (_, __) => divider,
                physics: const AlwaysScrollableScrollPhysics(),
                pagingController: viewModel.pagingController,
                builderDelegate: PagedChildBuilderDelegate<AthleteView>(
                  // Build individual athlete items
                  itemBuilder: (context, athlete, index) =>
                      AthleteTableItem(athlete: athlete),
                  // Handle error on first page load
                  firstPageErrorIndicatorBuilder: (context) => ErrorScreen(
                    error: context.l10n.errorOnLoadingAthletes,
                    onRetry: () => viewModel.pagingController.refresh(),
                  ),
                  // Handle error on subsequent page loads
                  newPageErrorIndicatorBuilder: (context) => ErrorScreen(
                    error: context.l10n.errorOnLoadingMoreAthletes,
                    onRetry: () =>
                        viewModel.pagingController.retryLastFailedRequest(),
                  ),
                  // Display message when no athletes are found
                  noItemsFoundIndicatorBuilder: (context) => Center(
                    child: Text(context.l10n.noAthletes),
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
