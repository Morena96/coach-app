import 'package:coach_app/core/theme/app_text_style.dart';
import 'package:coach_app/shared/constants/app_constants.dart';
import 'package:coach_app/shared/extensions/int.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

extension ContextX on BuildContext {
  double get width => MediaQuery.of(this).size.width;
  bool get isMobile => width < AppConstants.mobileBreakpoint;
  bool get isDesktop => width >= AppConstants.desktopBreakpoint;

  ColorScheme get color => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Default padding of pages
  EdgeInsets pagePadding({double? top, double? bottom}) => EdgeInsets.only(
        left: isMobile ? 20 : 40,
        top: top ?? (isMobile ? 20 : 40),
        right: isMobile ? 20 : 60,
        bottom: bottom ?? (isMobile ? 20 : 60),
      );

  void showSnackbar(String message,
      {bool showCheckIcon = false, Duration? duration, TextStyle? textStyle}) {
    final text = Text(
      message,
      style: textStyle ?? AppTextStyle.primary16b,
    );
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        duration: duration ?? 5.s,
        content: showCheckIcon
            ? Row(
                children: [
                  SvgPicture.asset('assets/icons/check-mark-circle-filled.svg'),
                  const SizedBox(width: 8),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: text,
                  ),
                ],
              )
            : text,
      ),
    );
  }
}
