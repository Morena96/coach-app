import 'package:coach_app/features/athletes/presentation/models/sport_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import 'package:coach_app/core/theme/app_colors.dart';
import 'package:coach_app/core/theme/app_text_style.dart';
import 'package:coach_app/core/widgets/app_dialog.dart';
import 'package:coach_app/core/widgets/avatar_image.dart';
import 'package:coach_app/core/widgets/blurry_toast.dart';
import 'package:coach_app/features/athletes/presentation/models/athlete_view.dart';
import 'package:coach_app/features/athletes/presentation/models/group_role_view.dart';
import 'package:coach_app/features/athletes/presentation/models/member_with_athlete_view.dart';
import 'package:coach_app/features/athletes/presentation/providers/group_member_view_model_provider.dart';
import 'package:coach_app/features/athletes/presentation/widgets/archived_chip.dart';
import 'package:coach_app/l10n.dart';
import 'package:coach_app/shared/extensions/context.dart';

/// Displays a single group member's information in the table.
/// Displays a single group member's information in the table with a checkbox for selection.
class GroupMemberTableItem extends StatelessWidget {
  final MemberWithAthleteView memberWithAthlete;
  final String groupId;
  final bool isSelected;
  final Function(String) onToggleSelection;

  const GroupMemberTableItem({
    super.key,
    required this.memberWithAthlete,
    required this.groupId,
    required this.isSelected,
    required this.onToggleSelection,
  });

  @override
  Widget build(BuildContext context) {
    return context.isMobile
        ? GroupMemberMobileTableItem(
            memberWithAthlete: memberWithAthlete,
            groupId: groupId,
            isSelected: isSelected,
            onToggleSelection: onToggleSelection,
          )
        : GroupMemberDesktopTableItem(
            memberWithAthlete: memberWithAthlete,
            groupId: groupId,
            isSelected: isSelected,
            onToggleSelection: onToggleSelection,
          );
  }
}

class GroupMemberDesktopTableItem extends StatelessWidget {
  const GroupMemberDesktopTableItem({
    super.key,
    required this.memberWithAthlete,
    required this.groupId,
    required this.isSelected,
    required this.onToggleSelection,
  });

  final MemberWithAthleteView memberWithAthlete;
  final String groupId;
  final bool isSelected;
  final Function(String) onToggleSelection;

  @override
  Widget build(BuildContext context) {
    final sports = memberWithAthlete.athlete.sports ?? [];
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 10, 16, 10),
      child: Row(
        children: [
          Checkbox(
            value: isSelected,
            onChanged: (_) => onToggleSelection(memberWithAthlete.member.id),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: GroupMemberTableItemAvatarAndName(
                athlete: memberWithAthlete.athlete),
          ),
          const SizedBox(width: 20),
          Expanded(
            flex: 2,
            child: Text(
              memberWithAthlete.member.role.title(context),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            flex: 3,
            child: _buildSports(sports),
          ),
          const SizedBox(width: 20),
          GroupMemberDeleteButton(
            memberWithAthlete: memberWithAthlete,
            groupId: groupId,
          )
        ],
      ),
    );
  }
}

Widget _buildSports(List<SportView> sports) {
  return sports.isNotEmpty
      ? Wrap(
          spacing: 16,
          runSpacing: 4,
          children: sports
              .map((sport) => Text(
                    sport.name,
                    style: const TextStyle(color: AppColors.primaryGreen),
                  ))
              .toList(),
        )
      : const Text('-');
}

class GroupMemberMobileTableItem extends StatelessWidget {
  const GroupMemberMobileTableItem({
    super.key,
    required this.memberWithAthlete,
    required this.groupId,
    required this.isSelected,
    required this.onToggleSelection,
  });

  final MemberWithAthleteView memberWithAthlete;
  final String groupId;
  final bool isSelected;
  final Function(String) onToggleSelection;

  @override
  Widget build(BuildContext context) {
    final sports = memberWithAthlete.athlete.sports ?? [];
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: ExpansionTile(
        leading: Checkbox(
          value: isSelected,
          onChanged: (_) => onToggleSelection(memberWithAthlete.member.id),
        ),
        title: GroupMemberTableItemAvatarAndName(
            athlete: memberWithAthlete.athlete),
        childrenPadding: const EdgeInsets.symmetric(vertical: 10),
        tilePadding: EdgeInsets.zero,
        children: [
          if (sports.isNotEmpty) Row(children: [_buildSports(sports)]),
          Row(children: [
            Expanded(
              flex: 2,
              child: Text(memberWithAthlete.member.role.name),
            ),
            GroupMemberDeleteButton(
              memberWithAthlete: memberWithAthlete,
              groupId: groupId,
            ),
          ])
        ],
      ),
    );
  }
}

class GroupMemberTableItemAvatarAndName extends StatelessWidget {
  const GroupMemberTableItemAvatarAndName({
    super.key,
    required this.athlete,
  });

  final AthleteView athlete;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AvatarImage(avatarPath: athlete.avatarPath, size: 44),
        const SizedBox(width: 9),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        athlete.name,
                        style: AppTextStyle.primary16b,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: SvgPicture.asset('assets/icons/verified-mark.svg'),
                  ),
                ],
              ),
              if (athlete.archived) const ArchivedChip(),
            ],
          ),
        ),
      ],
    );
  }
}

class GroupMemberDeleteButton extends ConsumerWidget {
  const GroupMemberDeleteButton({
    super.key,
    required this.memberWithAthlete,
    required this.groupId,
  });

  final MemberWithAthleteView memberWithAthlete;
  final String groupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: 60,
      alignment: Alignment.centerRight,
      child: IconButton(
        onPressed: () async {
          final confirm = await showDialog<bool>(
            context: context,
            builder: (_) => GroupMemberDeleteConfirmDialog(
              athlete: memberWithAthlete.athlete,
            ),
          );
          if (confirm == true) {
            final success = await ref
                .read(groupMembersViewModelProvider(groupId).notifier)
                .deleteItem(memberWithAthlete);
            showBlurryToast(
              context,
              success
                  ? context.l10n.groupMemberDeleted
                  : context.l10n.failedToDeleteGroupMember,
            );
          }
        },
        constraints: const BoxConstraints(),
        icon: SvgPicture.asset('assets/icons/trash.svg'),
      ),
    );
  }
}

/// Confirmation dialog for deleting a member from group
class GroupMemberDeleteConfirmDialog extends StatelessWidget {
  const GroupMemberDeleteConfirmDialog({
    super.key,
    required this.athlete,
  });

  final AthleteView athlete;

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: context.l10n.areYouSure,
      content: Text(
        context.l10n.deleteGroupMemberConfirmText(athlete.name),
        style: AppTextStyle.secondary14r,
        textAlign: TextAlign.center,
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(
            context.l10n.delete,
            style: AppTextStyle.primary14b,
          ),
        ),
        const SizedBox(height: 20),
        OutlinedButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            context.l10n.cancel,
            style: AppTextStyle.secondary14r,
          ),
        )
      ],
    );
  }
}
