import 'package:coach_app/core/theme/app_colors.dart';
import 'package:coach_app/shared/extensions/context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:coach_app/core/theme/app_text_style.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    this.iconPath,
    this.onPressed,
  });
  final String label;
  final String? iconPath;
  final VoidCallback? onPressed;

  factory PrimaryButton.add({
    required String label,
    VoidCallback? onPressed,
  }) =>
      PrimaryButton(
        label: label,
        onPressed: onPressed,
        iconPath: 'assets/icons/add.svg',
      );

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding:
            context.isMobile ? const EdgeInsets.fromLTRB(10, 8, 10, 4) : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (iconPath != null) ...[
            SvgPicture.asset(
              iconPath!,
              colorFilter:
                  const ColorFilter.mode(AppColors.black, BlendMode.srcIn),
            ),
            const SizedBox(width: 6),
          ],
          Text(label, style: AppTextStyle.primary14b),
        ],
      ),
    );
  }
}
