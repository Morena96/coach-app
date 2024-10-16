import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:coach_app/features/athletes/presentation/providers/athlete_form_provider.dart';
import 'package:coach_app/features/athletes/presentation/widgets/avatar_upload.dart';
import 'package:coach_app/l10n.dart';

/// Widget for uploading an athlete's profile picture
class AthleteAvatarUpload extends ConsumerWidget {
  const AthleteAvatarUpload({super.key, this.existingAvatarId});
  final String? existingAvatarId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(athleteFormProvider);
    final formNotifier = ref.read(athleteFormProvider.notifier);

    return AvatarUpload(
      existingAvatarPath: existingAvatarId,
      onAvatarSelected: (imageData) =>
          formNotifier.setAvatar(imageData, shouldUpdate: true),
      onAvatarDeleted: formNotifier.deleteAvatar,
      avatarStatus: formState.avatarStatus,
      currentAvatar: formState.avatar,
      selectLabel: context.l10n.selectProfilePicture,
      changeLabel: context.l10n.changeProfilePicture,
      deleteLabel: context.l10n.deleteProfilePicture,
      uploadingLabel: context.l10n.uploading,
    );
  }
}
