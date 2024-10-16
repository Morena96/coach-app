import 'package:flutter/material.dart';

import 'package:coach_app/core/widgets/layout/bread_crumbles.dart';
import 'package:coach_app/shared/extensions/context.dart';

/// A flexible page layout widget that uses a [CustomScrollView] with slivers.
/// With this layout whole page will be scrollable with sticky header.
///
/// This widget provides a customizable page layout with optional header, footer,
/// and either a child widget or a sliver widget as the main content.
class PageSliverLayout extends StatelessWidget {
  /// The header widget to be displayed at the top of the page.
  final Widget? header;

  /// The height of the header widget.
  final double headerHeight;

  /// The footer widget to be displayed at the bottom of the page.
  final Widget? footer;

  /// Whether to show breadcrumbs at the top of the page.
  final bool? showBreadCrumbles;

  /// The main content of the page as a regular non-scrollable widget.
  final Widget? child;

  /// The main content of the page as a sliver widget.
  final Widget? sliver;

  /// A callback function to handle pull-to-refresh.
  final Future<void> Function()? onRefresh;

  /// Creates a [PageSliverLayout].
  ///
  /// Either [child] or [sliver] must be provided, but not both.
  const PageSliverLayout({
    super.key,
    this.header,
    this.headerHeight = 88,
    this.footer,
    this.showBreadCrumbles = true,
    this.child,
    this.sliver,
    this.onRefresh,
  }) : assert(child != null || sliver != null);

  @override
  Widget build(BuildContext context) {
    final scrollView = CustomScrollView(
      slivers: [
        if (header != null)
          SliverPersistentHeader(
            floating: true,
            delegate: _FlexibleHeaderDelegate(
              height: headerHeight,
              child: Column(
                children: [
                  if (showBreadCrumbles == true) const BreadCrumbles(),
                  header!,
                ],
              ),
            ),
          ),
        if (sliver != null)
          sliver!
        else
          SliverToBoxAdapter(
            child: Padding(
              padding: context.pagePadding(),
              child: child,
            ),
          ),
        if (footer != null)
          SliverToBoxAdapter(
            child: footer!,
          ),
      ],
    );

    return onRefresh != null
        ? RefreshIndicator(
            onRefresh: onRefresh!,
            child: scrollView,
          )
        : scrollView;
  }
}

/// A delegate for creating a flexible header in [PageSliverLayout].
class _FlexibleHeaderDelegate extends SliverPersistentHeaderDelegate {
  /// The child widget to be displayed in the header.
  final Widget child;

  /// The height of the header.
  final double height;

  /// Creates a [_FlexibleHeaderDelegate].
  _FlexibleHeaderDelegate({
    required this.child,
    required this.height,
  });

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.color.surface,
      ),
      child: child,
    );
  }

  @override
  bool shouldRebuild(_FlexibleHeaderDelegate oldDelegate) =>
      oldDelegate.child != child;
}
