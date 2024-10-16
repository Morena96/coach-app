import 'package:coach_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A custom button that displays an icon on a colored background.
class SquareIconButton extends StatelessWidget {
  /// The icon to display in the button.
  final String iconPath;

  /// The function to call when the button is pressed.
  final VoidCallback onPressed;

  /// The size of the button (width and height will be equal).
  final double size;

  /// The color of the button's background.
  final Color backgroundColor;

  /// The color of the icon.
  final Color iconColor;

  final double? iconSize;

  const SquareIconButton({
    super.key,
    required this.iconPath,
    required this.onPressed,
    required this.size,
    this.iconSize,
    this.backgroundColor = AppColors.primaryGreen,
    this.iconColor = AppColors.black,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: iconColor,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        child: SvgPicture.asset(
          iconPath,
          width: iconSize ?? size * .5,
          colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
        ),
      ),
    );
  }
}
