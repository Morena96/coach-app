import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'package:coach_app/core/theme/app_text_style.dart';
import 'package:coach_app/core/widgets/screens/error_screen.dart';
import 'package:coach_app/features/athletes/presentation/models/group_view.dart';
import 'package:coach_app/features/athletes/presentation/providers/athlete_group_view_model_provider.dart';
import 'package:coach_app/features/athletes/presentation/widgets/group_table_item.dart';
import 'package:coach_app/l10n.dart';
import 'package:coach_app/shared/constants/app_constants.dart';

class AthleteProfileProfileTab extends ConsumerWidget {
  /// Creates an [AthleteProfileProfileTab].
  const AthleteProfileProfileTab({
    super.key,
    required this.athleteId,
  });

  /// The ID of the athlete whose profile is being displayed.
  final String athleteId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel =
        ref.watch(athleteGroupsViewModelProvider(athleteId).notifier);

    return LayoutBuilder(builder: (context, constraints) {
      final isWideScreen =
          constraints.maxWidth > AppConstants.desktopBreakpoint;
      final crossAxisCount = isWideScreen ? 3 : 2;
      return CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              height: 200,
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: const Text(
                'About Section',
                style: AppTextStyle.primary26b,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                context.l10n.groups,
                style: AppTextStyle.primary26b,
              ),
            ),
          ),
          constraints.maxWidth < AppConstants.mobileBreakpoint
              ? PagedSliverList<int, GroupView>(
                  pagingController: viewModel.pagingController,
                  builderDelegate: PagedChildBuilderDelegate<GroupView>(
                    itemBuilder: (context, group, index) => Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: GroupTableItem(group: group),
                    ),
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
                )
              : PagedSliverGrid<int, GroupView>(
                  pagingController: viewModel.pagingController,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisExtent: 172,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                  ),
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
                )
        ],
      );
    });
  }
}
