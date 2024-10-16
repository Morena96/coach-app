import 'dart:typed_data';

import 'package:domain/features/avatars/entities/avatar_status.dart';
import 'package:domain/features/avatars/entities/image_data.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:coach_app/core/theme/app_colors.dart';
import 'package:coach_app/core/theme/app_text_style.dart';
import 'package:coach_app/core/widgets/app_network_image.dart';
import 'package:coach_app/core/widgets/avatar_image.dart';
import 'package:coach_app/core/widgets/icon_text_button.dart';
import 'package:coach_app/core/widgets/image_cropper.dart';
import 'package:coach_app/features/avatars/infrastructure/models/memory_image_data.dart';
import 'package:coach_app/l10n.dart';

/// A reusable widget for avatar image upload and management.
class AvatarUpload extends ConsumerWidget {
  /// Path to an existing avatar image, if any.
  final String? existingAvatarPath;

  /// Callback function when a new avatar is selected.
  final void Function(ImageData) onAvatarSelected;

  /// Callback function when the avatar is deleted.
  final void Function() onAvatarDeleted;

  /// Current status of the avatar upload process.
  final AvatarStatus avatarStatus;

  /// Current avatar image data, if any.
  final ImageData? currentAvatar;

  /// Label for the select button.
  final String selectLabel;

  /// Label for the change button.
  final String changeLabel;

  /// Label for the delete button.
  final String deleteLabel;

  /// Label for the uploading status.
  final String uploadingLabel;

  /// Creates an [AvatarUpload] widget.
  const AvatarUpload({
    super.key,
    this.existingAvatarPath,
    required this.onAvatarSelected,
    required this.onAvatarDeleted,
    required this.avatarStatus,
    this.currentAvatar,
    required this.selectLabel,
    required this.changeLabel,
    required this.deleteLabel,
    required this.uploadingLabel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 4),
        Text(context.l10n.image, style: AppTextStyle.primary16b),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildAvatarImage(),
            const SizedBox(width: 16),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildUploadButton(context),
                  if (currentAvatar != null || existingAvatarPath != null) ...[
                    const SizedBox(height: 8),
                    _buildDeleteButton(context),
                  ],
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildAvatarImage() {
    if (currentAvatar != null) {
      return AppNetworkImage(
        imageBytes: currentAvatar!.getBytes(),
        size: 140,
      );
    } else if (existingAvatarPath != null) {
      return AvatarImage(
        avatarPath: existingAvatarPath!,
        size: 140,
      );
    } else {
      return DottedBorder(
        color: AppColors.grey200,
        borderType: BorderType.RRect,
        dashPattern: const [8, 4],
        radius: const Radius.circular(8),
        strokeWidth: 1,
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Image.asset(
            'assets/images/empty-image.png',
            width: 80,
            height: 80,
          ),
        ),
      );
    }
  }

  Widget _buildUploadButton(BuildContext context) {
    final buttonText = avatarStatus == AvatarStatus.selected
        ? changeLabel
        : avatarStatus == AvatarStatus.uploading
            ? '$uploadingLabel...'
            : selectLabel;

    return IconTextButton(
      label: buttonText,
      color: AppColors.primaryGreen,
      iconPath: 'assets/icons/upload.svg',
      onPressed: avatarStatus == AvatarStatus.uploading
          ? null
          : () => _selectImage(context),
    );
  }

  Widget _buildDeleteButton(BuildContext context) {
    return IconTextButton(
      label: deleteLabel,
      color: AppColors.additionalRed,
      iconPath: 'assets/icons/trash.svg',
      onPressed: onAvatarDeleted,
    );
  }

  Future<void> _selectImage(BuildContext context) async {
    final result = await showDialog<Uint8List>(
      context: context,
      builder: (context) => ImageCropper(
        onCropComplete: (Uint8List croppedImage) {
          Navigator.of(context).pop(croppedImage);
        },
      ),
    );

    if (result != null) {
      final imageData = MemoryImageData(result);
      if (context.mounted) {
        onAvatarSelected(imageData);
      }
    }
  }
}
