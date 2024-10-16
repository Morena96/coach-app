import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:coach_app/core/theme/app_text_style.dart';

/// A custom button widget that displays an icon (optional) and text.
///
/// This widget creates a button with a text label and an optional icon.
/// The icon is displayed to the left of the text if provided.
class IconTextButton extends StatelessWidget {
  /// Creates an [IconTextButton].
  ///
  /// The [label] parameter is required and specifies the text to be displayed.
  /// The [iconPath] is optional and specifies the path to the SVG icon.
  /// The [onPressed] callback is called when the button is tapped.
  /// The [color] parameter can be used to customize the color of both the icon and text.
  const IconTextButton({
    super.key,
    required this.label,
    this.iconPath,
    this.onPressed,
    this.color,
  });

  /// The text to display on the button.
  final String label;

  /// The path to the SVG icon file. If null, no icon will be displayed.
  final String? iconPath;

  /// Called when the button is tapped.
  final VoidCallback? onPressed;

  /// The color to use for the icon and text. If null, the default color will be used.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Row(
        children: [
          if (iconPath != null) ...[
            SvgPicture.asset(
              iconPath!,
              colorFilter: color != null
                  ? ColorFilter.mode(color!, BlendMode.srcIn)
                  : null,
            ),
            const SizedBox(width: 8)
          ],
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                label,
                style: AppTextStyle.primary14b.copyWith(color: color),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
