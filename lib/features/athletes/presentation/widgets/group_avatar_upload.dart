import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:coach_app/features/athletes/presentation/providers/group_form_provider.dart';
import 'package:coach_app/features/athletes/presentation/widgets/avatar_upload.dart';
import 'package:coach_app/l10n.dart';

/// A widget for uploading and managing a group's avatar image.
///
/// This widget uses the reusable [AvatarUpload] component to handle
/// the group avatar upload process, including selecting, changing,
/// and deleting the avatar.
class GroupAvatarUpload extends ConsumerWidget {
  /// Creates a [GroupAvatarUpload] widget.
  ///
  /// The [existingAvatarId] parameter is optional and represents
  /// the path to an existing avatar image, if any.
  const GroupAvatarUpload({super.key, this.existingAvatarId});

  /// The path to the existing avatar image, if any.
  final String? existingAvatarId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch only the avatar-related state
    final avatarStatus =
        ref.watch(groupFormProvider.select((state) => state.avatarStatus));
    final avatar = ref.watch(groupFormProvider.select((state) => state.avatar));

    // Use .read() for the notifier since we don't need to watch it
    final formNotifier = ref.read(groupFormProvider.notifier);

    return AvatarUpload(
      existingAvatarPath: existingAvatarId,
      onAvatarSelected: (imageData) =>
          formNotifier.setAvatar(imageData, shouldUpdate: true),
      onAvatarDeleted: formNotifier.deleteAvatar,
      avatarStatus: avatarStatus,
      currentAvatar: avatar,
      selectLabel: context.l10n.selectGroupPicture,
      changeLabel: context.l10n.changeGroupPicture,
      deleteLabel: context.l10n.deleteGroupPicture,
      uploadingLabel: context.l10n.uploading,
    );
  }
}
