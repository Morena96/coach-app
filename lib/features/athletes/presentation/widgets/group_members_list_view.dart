import 'package:coach_app/core/widgets/app_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'package:coach_app/core/theme/app_colors.dart';
import 'package:coach_app/core/theme/app_text_style.dart';
import 'package:coach_app/core/widgets/app_dialog.dart';
import 'package:coach_app/core/widgets/blurry_toast.dart';
import 'package:coach_app/core/widgets/screens/error_screen.dart';
import 'package:coach_app/features/athletes/presentation/models/member_with_athlete_view.dart';
import 'package:coach_app/features/athletes/presentation/providers/group_member_view_model_provider.dart';
import 'package:coach_app/features/athletes/presentation/providers/group_members_view_model.dart';
import 'package:coach_app/features/athletes/presentation/widgets/group_member_table_header.dart';
import 'package:coach_app/features/athletes/presentation/widgets/group_member_table_item.dart';
import 'package:coach_app/l10n.dart';
import 'package:coach_app/shared/extensions/context.dart';

/// Displays a list view of group members with pagination support.
class GroupsMembersListView extends ConsumerStatefulWidget {
  final String groupId;

  const GroupsMembersListView({required this.groupId, super.key});

  @override
  ConsumerState<GroupsMembersListView> createState() =>
      _GroupsMembersListViewState();
}

class _GroupsMembersListViewState extends ConsumerState<GroupsMembersListView> {
  late final GroupMembersViewModel viewModel;
  Set<String> selectedMembers = {};

  @override
  void initState() {
    super.initState();
    viewModel =
        ref.read(groupMembersViewModelProvider(widget.groupId).notifier);
  }

  @override
  Widget build(BuildContext context) {
    final divider =
        Container(height: 1, color: context.color.onSurface.withOpacity(.08));

    return Column(
      children: [
        if (selectedMembers.isNotEmpty) _selectionActions(context),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: context.color.tertiary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const GroupMemberTableHeader(),
                const AppDivider(),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      viewModel.refresh();
                      return Future.delayed(const Duration(seconds: 1));
                    },
                    child: PagedListView<int, MemberWithAthleteView>.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      pagingController: viewModel.pagingController,
                      separatorBuilder: (_, __) => divider,
                      builderDelegate:
                          PagedChildBuilderDelegate<MemberWithAthleteView>(
                        itemBuilder: (context, memberWithAthlete, index) =>
                            GroupMemberTableItem(
                          memberWithAthlete: memberWithAthlete,
                          groupId: widget.groupId,
                          isSelected: selectedMembers
                              .contains(memberWithAthlete.member.id),
                          onToggleSelection: toggleMemberSelection,
                        ),
                        firstPageErrorIndicatorBuilder: (context) =>
                            ErrorScreen(
                          error: context.l10n.loadGroupMembersError,
                          onRetry: () => viewModel.pagingController.refresh(),
                        ),
                        newPageErrorIndicatorBuilder: (context) => ErrorScreen(
                          error: context.l10n.loadGroupMembersError,
                          onRetry: () => viewModel.pagingController
                              .retryLastFailedRequest(),
                        ),
                        noItemsFoundIndicatorBuilder: (context) => Center(
                          child: Text(context.l10n.noGroupMembers),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Padding _selectionActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment:
            context.isDesktop ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (context.isDesktop) ...[
            Text('${selectedMembers.length} items selected',
                style: AppTextStyle.secondary14r),
            const Spacer(),
          ],
          TextButton(
            onPressed: () => setState(() => selectedMembers.clear()),
            child: Text(
              context.l10n.clearSelection,
              style: AppTextStyle.primary14b
                  .copyWith(color: context.color.onSurface),
            ),
          ),
          TextButton(
            onPressed: _deleteMembers,
            child: Text(
              context.l10n.deleteSelectedMembers,
              style: AppTextStyle.primary14b
                  .copyWith(color: AppColors.additionalRed),
            ),
          ),
        ],
      ),
    );
  }

  /// Toggle selection of a member
  void toggleMemberSelection(String memberId) {
    setState(() {
      if (selectedMembers.contains(memberId)) {
        selectedMembers.remove(memberId);
      } else {
        selectedMembers.add(memberId);
      }
    });
  }

  /// Clear all selections
  void _deleteMembers() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AppConfirmDialog(
        content: context.l10n.deleteGroupMembersConfirmText,
        positiveLabel: context.l10n.delete,
      ),
    );
    if (confirm == true) {
      final result = await ref
          .read(groupMembersViewModelProvider(widget.groupId).notifier)
          .deleteMembersFromGroup(selectedMembers.join(','));
      showBlurryToast(
        context,
        result.isSuccess
            ? context.l10n.groupMemberDeleted
            : context.l10n.failedToDeleteGroupMember,
      );
      setState(() => selectedMembers.clear());
    }
  }
}
