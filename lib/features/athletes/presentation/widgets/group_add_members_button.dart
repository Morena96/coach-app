import 'package:flutter/material.dart';

import 'package:coach_app/core/theme/app_text_style.dart';
import 'package:coach_app/features/athletes/presentation/widgets/group_add_member_dialog.dart';
import 'package:coach_app/l10n.dart';

/// A button widget that allows adding members to a group.
///
/// This button is enabled only when [groupId] is not null. When pressed,
/// it shows a dialog or modal for adding members to the specified group.
class GroupAddMembersButton extends StatelessWidget {
  const GroupAddMembersButton({super.key, required this.groupId});
  final String? groupId;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: groupId != null
          ? () => showDialog(
                context: context,
                builder: (_) => GroupAddMemberDialog(groupId: groupId!),
              )
          : null,
      child: Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Text(
          context.l10n.addMembers,
          style: AppTextStyle.primary14b,
        ),
      ),
    );
  }
}
