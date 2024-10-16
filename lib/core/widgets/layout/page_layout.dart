import 'package:flutter/material.dart';

import 'package:coach_app/core/widgets/layout/bread_crumbles.dart';
import 'package:coach_app/shared/extensions/context.dart';

/// A simple page layout widget that arranges its children in a column.
/// In this layout, child is expanded and can be scrollable. Header and footer
/// remains fixed.
///
/// This widget provides a basic page structure with optional header, footer,
/// and a required child widget as the main content.
class PageLayout extends StatelessWidget {
  /// The header widget to be displayed at the top of the page.
  final Widget? header;

  /// The footer widget to be displayed at the bottom of the page.
  final Widget? footer;

  /// Whether to show breadcrumbs at the top of the page.
  final bool? showBreadCrumbles;

  /// The main content of the page.
  final Widget child;

  /// Creates a [PageLayout].
  ///
  /// The [child] parameter is required, while [header], [footer],
  /// and [showBreadCrumbles] are optional.
  const PageLayout({
    super.key,
    this.header,
    this.footer,
    this.showBreadCrumbles = true,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          if (showBreadCrumbles == true) const BreadCrumbles(),
          if (header != null) header!,
          Expanded(
            child: Padding(
              padding: context.pagePadding(top: 24, bottom: 30),
              child: child,
            ),
          ),
          if (footer != null) footer!,
        ],
    );
  }
}
