import 'package:domain/features/avatars/entities/image_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:coach_app/core/widgets/app_network_image.dart';
import 'package:coach_app/features/avatars/infrastructure/provider/avatar_repository_provider.dart';

/// Widget to display an athlete's avatar image
class AvatarImage extends ConsumerWidget {
  const AvatarImage({
    super.key,
    required this.avatarPath,
    required this.size,
    this.imageData,
  });

  final String avatarPath;
  final double size;
  final ImageData? imageData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (imageData != null) {
      return AppNetworkImage(
        imageBytes: imageData!.getBytes(),
        size: size,
      );
    }

    final avatarRepository = ref.watch(avatarRepositoryProvider);
    final futureImageData = avatarRepository.getAvatarImage(avatarPath);

    return FutureBuilder<ImageData?>(
      future: futureImageData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            width: size,
            height: size,
            child: const CircularProgressIndicator(),
          );
        }

        return AppNetworkImage(
          imageBytes: snapshot.data?.getBytes(),
          imagePath: avatarPath,
          size: size,
        );
      },
    );
  }
}
