import 'package:coach_app/core/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:coach_app/core/router/routes.dart';
import 'package:coach_app/core/widgets/layout/bread_crumb_provider.dart';
import 'package:coach_app/core/widgets/layout/page_header.dart';
import 'package:coach_app/core/widgets/layout/page_layout.dart';
import 'package:coach_app/core/widgets/layout/vertical_tabs.dart';
import 'package:coach_app/features/athletes/presentation/models/group_view.dart';
import 'package:coach_app/features/athletes/presentation/providers/group_form_provider.dart';
import 'package:coach_app/features/athletes/presentation/providers/groups_view_model.dart';
import 'package:coach_app/features/athletes/presentation/providers/groups_view_model_provider.dart';
import 'package:coach_app/features/athletes/presentation/widgets/group_add_members_button.dart';
import 'package:coach_app/features/athletes/presentation/widgets/group_avatar_upload.dart';
import 'package:coach_app/features/athletes/presentation/widgets/group_details_form.dart';
import 'package:coach_app/features/athletes/presentation/widgets/group_members_list_view.dart';
import 'package:coach_app/features/avatars/infrastructure/provider/avatar_repository_provider.dart';
import 'package:coach_app/l10n.dart';
import 'package:coach_app/shared/extensions/context.dart';

/// A page for creating or editing an group's profile.
class GroupFormPage extends ConsumerStatefulWidget {
  /// The group to edit. If null, a new group will be created.
  final GroupView? group;

  /// Creates an [GroupFormPage].
  ///
  /// If [group] is provided, the form will be in edit mode.
  const GroupFormPage({super.key, this.group});

  @override
  ConsumerState<GroupFormPage> createState() => _GroupFormPageState();
}

/// The state for [GroupFormPage].
class _GroupFormPageState extends ConsumerState<GroupFormPage>
    with SingleTickerProviderStateMixin {
  /// Key for the form to manage validation.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  GroupView? group;

  @override
  void initState() {
    super.initState();
    group = widget.group;
    if (widget.group != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _initializeEditMode(widget.group!);
      });
    }
  }

  /// Initializes the form with existing group data for edit mode.
  ///
  /// Fetches and sets the group's name, sports, and avatar.
  Future<void> _initializeEditMode(GroupView group) async {
    final formNotifier = ref.read(groupFormProvider.notifier);
    formNotifier.setName(group.name);
    formNotifier.setDescription(group.description);
    if (group.sport != null) formNotifier.setSport(group.sport!);

    if ((group.avatarId ?? '').isNotEmpty) {
      final avatarRepository = ref.read(avatarRepositoryProvider);
      final imageData = await avatarRepository.getAvatarImage(group.avatarId!);

      if (imageData != null) {
        formNotifier.setAvatar(imageData);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final formNotifier = ref.watch(groupFormProvider.notifier);
    final groupFormState = ref.watch(groupFormProvider);
    final isEditMode = widget.group != null;

    final groupId =
        isEditMode ? widget.group?.id : groupFormState.createdGroup?.id;

    return BreadcrumbProvider(
      customTitles: {
        '/groups/${widget.group?.id}': widget.group?.name ?? '',
        '/groups/${widget.group?.id}/edit': context.l10n.editGroup,
        Routes.groupsCreate.path: context.l10n.addGroup,
      },
      child: PageLayout(
        header: PageHeader(
          title: isEditMode ? context.l10n.editGroup : context.l10n.addGroup,
          actions: [
            if (context.isDesktop) ...[
              SizedBox(
                width: 180,
                child: OutlinedButton(
                  onPressed: Navigator.of(context).pop,
                  child: Text(context.l10n.cancel),
                ),
              ),
              const SizedBox(width: 16),
            ],
            Container(
              width: context.isDesktop ? 180 : 120,
              padding: context.isMobile ? const EdgeInsets.only(top: 8) : null,
              child: PrimaryButton(
                onPressed: groupFormState.isValid()
                    ? () => _onSaveGroupPressed(formNotifier, groupFormState,
                        ref.read(groupsViewModelProvider.notifier), isEditMode)
                    : null,
                label:
                    groupId != null ? context.l10n.save : context.l10n.addGroup,
              ),
            )
          ],
        ),
        child: VerticalTabs(
          tabs: [
            VerticalTab(
              title: context.l10n.groupDetails,
              paintIcon: !groupFormState.isValid(),
              iconPath: groupFormState.isValid()
                  ? 'assets/icons/check-mark-circle-filled.svg'
                  : 'assets/icons/check-mark-circle-outlined.svg',
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const GroupAvatarUpload(),
                  GroupDetailsForm(formKey: _formKey),
                ],
              ),
            ),
            VerticalTab(
              title: context.l10n.groupMembers,
              paintIcon: !groupFormState.isValid(),
              iconPath: (groupId ?? '').isNotEmpty
                  ? 'assets/icons/check-mark-circle-filled.svg'
                  : 'assets/icons/check-mark-circle-outlined.svg',
              content: (groupId ?? '').isEmpty
                  ? Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: context.color.tertiary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        context.l10n.pleaseSaveTheGroupToAddMembers,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    )
                  : GroupsMembersListView(groupId: groupId!),
              action: GroupAddMembersButton(groupId: groupId),
              isContentScrollable: true,
              contentConstraints: double.infinity,
              onSelect: () {
                // Save Group Details if not created & valid
                if (!isEditMode &&
                    groupFormState.createdGroup?.id == null &&
                    groupFormState.isValid()) {
                  _onSaveGroupPressed(formNotifier, groupFormState,
                      ref.read(groupsViewModelProvider.notifier), isEditMode);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Handles the save button press.
  ///
  /// Validates the form, saves or updates the group, and shows appropriate feedback.
  void _onSaveGroupPressed(GroupForm formNotifier, GroupFormState formState,
      GroupsViewModel groupsViewModel, bool isEditMode) async {
    final result = isEditMode || formState.createdGroup != null
        ? await formNotifier.update(widget.group ?? formState.createdGroup!)
        : await formNotifier.save();

    if (result.isSuccess) {
      context.showSnackbar(
        isEditMode ? context.l10n.groupUpdated : context.l10n.groupAdded,
        showCheckIcon: true,
      );

      // Reload GroupsListPage
      groupsViewModel.refresh();
      if (isEditMode) {
        // Reload GroupViewPage
        // ref
        //     .read(athleteViewViewModelProvider(widget.group!.id).notifier)
        //     .fetchAthlete(widget.group!.id);
      }
    } else {
      final message = isEditMode
          ? context.l10n.failedToUpdateGroup
          : context.l10n.failedToAddGroup;
      context.showSnackbar('$message: ${result.error}');
    }
  }
}
