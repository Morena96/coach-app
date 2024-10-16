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
import 'package:coach_app/features/athletes/presentation/providers/athletes_view_model_provider.dart';
import 'package:coach_app/features/athletes/presentation/providers/group_member_view_model_provider.dart';
import 'package:coach_app/features/athletes/presentation/widgets/group_quick_add_athlete_dialog.dart';
import 'package:coach_app/l10n.dart';
import 'package:coach_app/shared/extensions/context.dart';

/// Confirmation dialog for deleting an athlete.
/// Dialog for adding a new member to a group
class GroupAddMemberDialog extends ConsumerStatefulWidget {
  final String groupId;

  const GroupAddMemberDialog({
    required this.groupId,
    super.key,
  });

  @override
  ConsumerState<GroupAddMemberDialog> createState() =>
      _GroupAddMemberDialogState();
}

class _GroupAddMemberDialogState extends ConsumerState<GroupAddMemberDialog> {
  List<AthleteView> athletes = [];
  GroupRole role = GroupRole.athlete;

  @override
  void initState() {
    super.initState();
    ref
        .read(athletesViewModelProvider.notifier)
        .setCurrentGroupId(widget.groupId);
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: context.l10n.addNewMembers,
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
              if (athletes.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    context.l10n.athletesWillBeAddedToGroup(athletes.length),
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
                label: context.l10n.findAthletes,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PaginatedAutocompleteMultiSelector<AthleteView>(
                      onItemsSelected: (selectedAthletes) {
                        setState(() {
                          athletes = selectedAthletes;
                        });
                      },
                      viewModelProvider: athletesViewModelProvider,
                      labelBuilder: (athlete) => athlete.name,
                      onSearch: (query) => ref
                          .read(athletesViewModelProvider.notifier)
                          .updateNameFilter(query),
                      hintText: context.l10n.selectAthlete,
                      initialSelectedItems: athletes,
                      itemBuilder: (context, athlete) => _MemberCard(
                        athlete: athlete,
                      ),
                      positiveButtonLabel: context.l10n.addMembers,
                      noItemsFoundWidget: (hideOverlay, searchQuery) => Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              context.l10n.noAthletesFoundCreateNew,
                              style: AppTextStyle.primary16r
                                  .copyWith(color: AppColors.black),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () async {
                                hideOverlay();
                                final athlete = await showDialog<AthleteView>(
                                  context: context,
                                  builder: (_) => GroupQuickAddAthleteDialog(
                                      athleteName: searchQuery),
                                );
                                if (athlete != null) {
                                  setState(() => athletes.add(athlete));
                                }
                              },
                              child: Text(context.l10n.addNewAthlete),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 270),
                      child: SingleChildScrollView(
                        reverse: true,
                        child: ChipList<AthleteView>(
                          items: athletes,
                          labelBuilder: (sport) => sport.name,
                          onDeleted: (athlete) =>
                              setState(() => athletes.remove(athlete)),
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
            onPressed: athletes.isNotEmpty ? _addMembersToGroup : null,
            child: Text(
              context.l10n.addToTheGroup,
              style: AppTextStyle.primary14b,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _addMembersToGroup() async {
    final result = await ref
        .read(groupMembersViewModelProvider(widget.groupId).notifier)
        .batchAddMembersToGroup(athletes.map((a) => a.id).toList(), role);

    if (result.isSuccess) {
      if (mounted) {
        context.showSnackbar(
          context.l10n.athleteAddedToTheGroup(athletes.length),
          showCheckIcon: true,
        );
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

class _MemberCard extends StatelessWidget {
  const _MemberCard({
    required this.athlete,
  });
  final AthleteView athlete;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AvatarImage(
          avatarPath: athlete.avatarPath,
          size: 36,
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              athlete.name,
              style: AppTextStyle.primary14b.copyWith(color: Colors.black),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            if ((athlete.sports ?? []).isNotEmpty)
              Text(
                athlete.sports?.map((s) => s.name).join(', ') ?? '',
                style: AppTextStyle.secondary12r
                    .copyWith(color: AppColors.grey200, fontSize: 10),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
          ],
        )
      ],
      // leading: ,
      // title: ,
    );
  }
}
