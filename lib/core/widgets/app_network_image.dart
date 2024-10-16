import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

import 'package:coach_app/core/theme/app_colors.dart';
import 'package:coach_app/shared/extensions/context.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Displays a network image with placeholder and error handling.
class AppNetworkImage extends StatelessWidget {
  final String? imagePath;
  final List<int>? imageBytes;
  final double? size;

  const AppNetworkImage({
    super.key,
    this.imagePath,
    this.imageBytes,
    this.size,
  }) : assert(imagePath != null || imageBytes != null,
            'Either imagePath or imageBytes must be provided');

  @override
  Widget build(BuildContext context) {
    if (imagePath?.isEmpty ?? true && imageBytes == null) {
      return AppNetworkImagePlaceholder(size);
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        height: size,
        width: size,
        child: _buildImage(),
      ),
    );
  }

  bool _isSvg(List<int> bytes) {
    final header = String.fromCharCodes(bytes.take(5));
    return header.startsWith('<svg') || header.startsWith('<?xml');
  }

  Widget _buildImage() {
    if (imageBytes != null) {
      if (_isSvg(imageBytes!)) {
        return SvgPicture.memory(
          Uint8List.fromList(imageBytes!),
          fit: BoxFit.cover,
          placeholderBuilder: (context) => AppNetworkImagePlaceholder(size),
        );
      }
      return Image.memory(
        Uint8List.fromList(imageBytes!),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => AppNetworkImagePlaceholder(size),
      );
    } else if (imagePath != null) {
      if (imagePath!.startsWith('http')) {
        return CachedNetworkImage(
          imageUrl: imagePath!,
          fit: BoxFit.cover,
          placeholder: (_, __) => AppNetworkImagePlaceholder(size),
          errorWidget: (_, __, ___) => AppNetworkImagePlaceholder(size),
        );
      } else if (imagePath!.toLowerCase().endsWith('.svg')) {
        return SvgPicture.asset(
          imagePath!,
          fit: BoxFit.cover,
          placeholderBuilder: (context) => AppNetworkImagePlaceholder(size),
        );
      } else {
        return Image.asset(
          imagePath!,
          height: size,
          width: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => AppNetworkImagePlaceholder(size),
        );
      }
    } else {
      return AppNetworkImagePlaceholder(size);
    }
  }
}

/// Placeholder widget used when image is loading or on error.
class AppNetworkImagePlaceholder extends StatelessWidget {
  final double? size;
  const AppNetworkImagePlaceholder(this.size, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: context.color.onSurface.withOpacity(.1),
      ),
      child: const Icon(
        CupertinoIcons.person_alt,
        color: AppColors.grey200,
      ),
    );
  }
}
