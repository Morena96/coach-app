import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import 'package:coach_app/core/theme/app_text_style.dart';
import 'package:coach_app/shared/extensions/context.dart';

/// A widget that displays the header of a page, including title, actions, and an optional subtitle.
///
/// This widget adapts its layout based on whether it's on a root route or a nested route.
class PageHeader extends StatelessWidget {
  const PageHeader({
    super.key,
    this.title,
    this.titleWidget,
    this.actions,
    this.subtitle,
  });

  /// The main text to be displayed in the header.
  final String? title;

  final Widget? titleWidget;

  /// Optional list of widgets to be displayed on the right side of the header.
  final List<Widget>? actions;

  /// Optional widget to be displayed below the title and actions.
  final Widget? subtitle;

  @override
  Widget build(BuildContext context) {
    final isRootRoute = !GoRouter.of(context).canPop();
    return Padding(
      padding: context.pagePadding(top: 14, bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              // Display back button if not on a root route
              if (!isRootRoute) ...[
                InkWell(
                  onTap: context.pop,
                  borderRadius: BorderRadius.circular(8),
                  child: SvgPicture.asset('assets/icons/arrow-left-bold.svg',
                      colorFilter: ColorFilter.mode(
                          context.color.onSurface, BlendMode.srcIn)),
                ),
                const SizedBox(width: 24),
              ],
              // Display the title
              if (title != null)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 0),
                    child: Text(
                      title!,
                      style: AppTextStyle.primary18b.copyWith(
                          fontSize: (isRootRoute ? 32 : 26) *
                              (context.isDesktop ? 1 : .8)),
                    ),
                  ),
                ),
              if (titleWidget != null) titleWidget!,
              // Display actions if provided
              if (actions != null) ...actions!,
            ],
          ),

          // Display subtitle if provided
          if (subtitle != null)
            Container(
              padding: const EdgeInsets.only(top: 12),
              child: subtitle!,
            ),
        ],
      ),
    );
  }
}
