import 'package:domain/features/athletes/entities/group_role.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:coach_app/core/theme/app_colors.dart';
import 'package:coach_app/core/theme/app_text_style.dart';
import 'package:coach_app/core/widgets/app_dialog.dart';
import 'package:coach_app/core/widgets/app_dropdown.dart';
import 'package:coach_app/core/widgets/avatar_image.dart';
import 'package:coach_app/core/widgets/chip_list.dart';
import 'package:coach_app/core/widgets/form_label.dart';
import 'package:coach_app/core/widgets/paginated_autocomplete_multi_selector.dart';
import 'package:coach_app/features/athletes/presentation/models/athlete_view.dart';
import 'package:coach_app/features/athletes/presentation/models/group_role_extension.dart';
import 'package:coach_app/features/athletes/presentation/models/group_view.dart';
import 'package:coach_app/features/athletes/presentation/providers/athlete_group_view_model_provider.dart';
import 'package:coach_app/l10n.dart';
import 'package:coach_app/shared/extensions/context.dart';

/// A dialog widget that allows adding an athlete to one or more groups with a specific role.
/// Provides group search functionality and displays selected groups as chips.
class AthleteProfileAddToGroupDialog extends ConsumerStatefulWidget {
  final AthleteView athlete;

  const AthleteProfileAddToGroupDialog({
    required this.athlete,
    super.key,
  });

  @override
  ConsumerState<AthleteProfileAddToGroupDialog> createState() =>
      _GroupAddMemberDialogState();
}

class _GroupAddMemberDialogState
    extends ConsumerState<AthleteProfileAddToGroupDialog> {
  /// List of groups selected for the athlete to be added to
  List<GroupView> groups = [];

  /// The role that will be assigned to the athlete in the selected groups
  GroupRole role = GroupRole.athlete;

  @override
  void initState() {
    super.initState();
    ref.read(athletePotentialGroupsViewModelProvider(widget.athlete.id));
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: context.l10n.addToTheGroup,
      actionsDirection: ActionsDirection.horizontal,
      centerTitle: false,
      titleDivider: true,
      content: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  context.l10n
                      .athleteWillBeAddedToTheGroup(widget.athlete.name),
                  style: AppTextStyle.secondary16r,
                ),
              ),
              const SizedBox(height: 10),
              FormLabel(
                label: context.l10n.role,
                child: AppDropdown<GroupRole>(
                  backgroundColor: AppColors.white,
                  foregroundColor: AppColors.black,
                  padding: const EdgeInsets.only(left: 12, right: 8),
                  value: role,
                  items: GroupRole.values
                      .map((role) => DropdownMenuItem(
                            value: role,
                            child: Text(role.title(context)),
                          ))
                      .toList(),
                  onChanged: (GroupRole? newValue) {
                    if (newValue != null) {
                      setState(() => role = newValue);
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),
              FormLabel(
                label: context.l10n.findGroups,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PaginatedAutocompleteMultiSelector<GroupView>(
                      onItemsSelected: (selectedGroups) {
                        setState(() {
                          groups = selectedGroups;
                        });
                      },
                      viewModelProvider:
                          athletePotentialGroupsViewModelProvider(
                              widget.athlete.id),
                      labelBuilder: (group) => group.name,
                      onSearch: (query) => ref
                          .read(athletePotentialGroupsViewModelProvider(
                                  widget.athlete.id)
                              .notifier)
                          .updateNameFilter(query),
                      hintText: context.l10n.selectGroup,
                      initialSelectedItems: groups,
                      itemBuilder: (context, group) => _GroupCard(group: group),
                      positiveButtonLabel: context.l10n.addMembers,
                    ),
                    const SizedBox(height: 22),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 270),
                      child: SingleChildScrollView(
                        reverse: true,
                        child: ChipList<GroupView>(
                          items: groups,
                          labelBuilder: (group) => group.name,
                          onDeleted: (group) =>
                              setState(() => groups.remove(group)),
                          chipBackgroundColor: context.color.tertiary,
                          chipBorderColor:
                              context.color.onSurface.withOpacity(.14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              context.l10n.cancel,
              style: AppTextStyle.secondary14r,
            ),
          ),
        ),
        const SizedBox(width: 16, height: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: groups.isNotEmpty ? _addMembersToGroup : null,
            child: Text(
              context.l10n.addToTheGroup,
              style: AppTextStyle.primary14b,
            ),
          ),
        ),
      ],
    );
  }

  /// Handles the action of adding the athlete to the selected groups
  /// Shows success/error feedback via snackbar and closes the dialog on success
  Future<void> _addMembersToGroup() async {
    final result = await ref
        .read(athleteGroupsViewModelProvider(widget.athlete.id).notifier)
        .addGroupsToAthlete(groups.map((a) => a.id).toList(), role);

    if (result.isSuccess) {
      if (mounted) {
        context.showSnackbar(
          context.l10n.athleteAddedToTheGroups(widget.athlete.name),
          showCheckIcon: true,
        );

        /// reload groups on athlete profile page
        ref
            .read(athleteGroupsViewModelProvider(widget.athlete.id).notifier)
            .refresh();
        Navigator.of(context).pop(true);
      }
    } else {
      if (mounted) {
        context.showSnackbar(
          context.l10n.failedToAddMemberName(result.error.toString()),
        );
      }
    }
  }
}

/// A card widget displaying group information with an avatar and name
/// Used in the group selection autocomplete list
class _GroupCard extends StatelessWidget {
  const _GroupCard({
    required this.group,
  });
  final GroupView group;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AvatarImage(
          avatarPath: group.avatarId ?? '',
          size: 36,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              group.name,
              style: AppTextStyle.primary14b.copyWith(color: Colors.black),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ),
      ],
      // leading: ,
      // title: ,
    );
  }
}
