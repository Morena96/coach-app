import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:coach_app/core/router/routes.dart';
import 'package:coach_app/core/theme/app_colors.dart';
import 'package:coach_app/core/theme/app_text_style.dart';
import 'package:coach_app/core/widgets/app_dialog.dart';
import 'package:coach_app/core/widgets/avatar_image.dart';
import 'package:coach_app/core/widgets/blurry_toast.dart';
import 'package:coach_app/features/athletes/presentation/models/group_view.dart';
import 'package:coach_app/features/athletes/presentation/providers/groups_view_model_provider.dart';
import 'package:coach_app/l10n.dart';
import 'package:coach_app/shared/extensions/context.dart';

/// Displays a single athlete's information in the table.
class GroupTableItem extends StatelessWidget {
  final GroupView group;

  const GroupTableItem({
    super.key,
    required this.group,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.pushNamed(
        Routes.groupDetails.name,
        pathParameters: {'id': group.id},
        extra: group,
      ),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: context.color.tertiary,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AvatarImage(avatarPath: group.avatarId ?? '', size: 64),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (group.sport != null)
                    Container(
                      padding: const EdgeInsets.fromLTRB(14, 6, 14, 2),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.grey200),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        group.sport!.name,
                        style: AppTextStyle.primary12r.copyWith(
                          color: AppColors.primaryGreen,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  const SizedBox(height: 10),
                  Text(
                    group.name,
                    style: context.isMobile
                        ? AppTextStyle.primary16b
                        : AppTextStyle.primary20b,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if ((group.description ?? '').isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        group.description!,
                        style: context.isMobile
                            ? AppTextStyle.secondary14r
                            : AppTextStyle.secondary16r,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Deletes or restores a group based on their current status.
///
/// Shows a confirmation dialog before performing the action.
/// Displays a toast message indicating the result of the operation.
void deleteOrRestoreGroup(
  BuildContext context,
  GroupView group,
  WidgetRef ref, {
  VoidCallback? onSuccess,
}) async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (_) => GroupDeleteRestoreConfirmDialog(group: group),
  );

  if (confirm == true) {
    if (group.archived) {
      final success =
          await ref.read(groupsViewModelProvider.notifier).restoreGroup(group);
      showBlurryToast(
        context,
        success
            ? context.l10n.groupRestored
            : context.l10n.failedToRestoreGroup,
      );
      onSuccess?.call();
    } else {
      final success =
          await ref.read(groupsViewModelProvider.notifier).deleteItem(group);
      showBlurryToast(
        context,
        success
            ? context.l10n.groupArchived
            : context.l10n.failedToArchiveGroup,
      );
      onSuccess?.call();
    }
  }
}

/// Confirmation dialog for deleting a group.
class GroupDeleteRestoreConfirmDialog extends StatelessWidget {
  const GroupDeleteRestoreConfirmDialog({
    super.key,
    required this.group,
  });

  final GroupView group;

  @override
  Widget build(BuildContext context) {
    return AppConfirmDialog(
      content: group.archived
          ? context.l10n.restoreConfirmText(group.name)
          : context.l10n.archiveConfirmText(group.name),
      positiveLabel:
          group.archived ? context.l10n.restore : context.l10n.archive,
    );
  }
}
