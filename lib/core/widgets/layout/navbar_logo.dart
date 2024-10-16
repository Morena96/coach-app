import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:coach_app/core/theme/app_text_style.dart';

/// A widget that displays the logo in the navigation bar.
///
/// This widget adapts its layout based on whether the navigation bar is expanded or collapsed.
class NavbarLogo extends StatelessWidget {
  const NavbarLogo({
    super.key,
    required this.isExpanded,
  });

  /// Indicates whether the navigation bar is expanded.
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.only(left: isExpanded ? 40 : 20),
      child: Column(
        children: [
          // Display the logo SVG
          SvgPicture.asset(
            'assets/icons/fiyrpod-logo.svg',
            width: 38,
          ),
          const SizedBox(height: 11),
          // Display the logo text
          RichText(
            text: const TextSpan(
              text: 'FIYR',
              style: AppTextStyle.primary14b,
              children: [
                TextSpan(
                  text: 'POD',
                  style: AppTextStyle.primary14r,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}