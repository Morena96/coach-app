import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import 'package:coach_app/core/theme/app_colors.dart';
import 'package:coach_app/core/widgets/app_tabs.dart';
import 'package:coach_app/core/widgets/layout/bread_crumb_provider.dart';
import 'package:coach_app/core/widgets/layout/page_header.dart';
import 'package:coach_app/core/widgets/layout/page_layout.dart';
import 'package:coach_app/core/widgets/primary_button.dart';
import 'package:coach_app/core/widgets/square_icon_button.dart';
import 'package:coach_app/features/athletes/presentation/models/group_view.dart';
import 'package:coach_app/features/athletes/presentation/providers/group_view_model_provider.dart';
import 'package:coach_app/features/athletes/presentation/widgets/group_add_member_dialog.dart';
import 'package:coach_app/features/athletes/presentation/widgets/group_members_list_view.dart';
import 'package:coach_app/features/athletes/presentation/widgets/group_table_item.dart';
import 'package:coach_app/features/athletes/presentation/widgets/group_view_header.dart';
import 'package:coach_app/features/sessions/presentation/widgets/session_list_view.dart';
import 'package:coach_app/l10n.dart';
import 'package:coach_app/shared/extensions/context.dart';

/// A page for viewing an group's information.
class GroupViewPage extends ConsumerWidget {
  const GroupViewPage({super.key, required this.group});

  final GroupView group;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(groupViewViewModelProvider(group.id));

    return BreadcrumbProvider(
      customTitles: {'/groups/${group.id}': group.name},
      child: PageLayout(
        header: state.maybeWhen(
          data: (group) => PageHeader(
            titleWidget: GroupViewHeader(group: group),
            actions: [
              const SizedBox(width: 12),
              SquareIconButton(
                size: 38,
                iconPath: 'assets/icons/edit.svg',
                onPressed: () => context.push(
                  '/groups/${group.id}/edit',
                  extra: group,
                ),
              ),
              const SizedBox(width: 12),
              SquareIconButton(
                size: 38,
                iconPath: 'assets/icons/trash.svg',
                onPressed: () => deleteOrRestoreGroup(context, group, ref,
                    onSuccess: () => context.pop()),
                iconSize: group.archived ? 16 : null,
                iconColor: AppColors.black,
                backgroundColor: AppColors.lightRed,
              ),
            ],
            // subtitle: GroupProfileHeader(),
          ),
          orElse: () => null,
        ),
        child: state.when(
          data: (group) => AppTabs(
            isScrollable: true,
            action: context.isDesktop
                ? PrimaryButton.add(
                    label: context.l10n.addMembers,
                    onPressed: () => _addMembers(context),
                  )
                : Tooltip(
                    message: context.l10n.addNewMembers,
                    child: IconButton.filled(
                      onPressed: () => _addMembers(context),
                      icon: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: SvgPicture.asset('assets/icons/add.svg'),
                      ),
                      color: AppColors.primaryGreen,
                    ),
                  ),
            tabs: [
              context.l10n.members,
              context.l10n.statistics,
              context.l10n.sessions,
            ],
            tabContents: [
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: GroupsMembersListView(groupId: group.id),
              ),
              Center(child: Text(context.l10n.statistics)),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: SessionListView(groupId: group.id),
              ),
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(
            child: Text(context.l10n.errorText(error)),
          ),
        ),
      ),
    );
  }

  void _addMembers(BuildContext context) => showDialog(
        context: context,
        builder: (_) => GroupAddMemberDialog(groupId: group.id),
      );
}
