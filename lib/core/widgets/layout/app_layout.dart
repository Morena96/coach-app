import 'package:coach_app/shared/extensions/int.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:coach_app/core/widgets/layout/custom_app_bar.dart';
import 'package:coach_app/core/widgets/layout/navbar.dart';
import 'package:coach_app/shared/constants/app_constants.dart';
import 'package:coach_app/shared/extensions/context.dart';
import 'package:coach_app/shared/providers/navbar_state_provider.dart';

/// A responsive layout widget that provides a structured layout for the application.
///
/// This widget creates a layout with a sidebar (NavBar) and a main content area.
/// It adapts to both mobile and desktop views, handling the sidebar visibility
/// and animations based on the current state and device type.
class AppLayout extends ConsumerWidget {
  /// The widget to be displayed in the main content area.
  final Widget child;

  const AppLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the navbar state to determine if the sidebar is expanded
    final navbarState = ref.watch(navbarStateProvider);
    final isExpanded = navbarState.expanded;

    // Check if the current device is mobile
    final isMobile = context.isMobile;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Row(
              children: [
                // Render the sidebar for non-mobile devices
                if (!isMobile) ...[
                  // Animated container for smooth sidebar width transitions
                  AnimatedContainer(
                    key: const ValueKey('desktop_navbar'),
                    duration: 200.ms,
                    width: isExpanded
                        ? AppConstants.sidebarExpandedWidth
                        : AppConstants.sidebarCollapsedWidth,
                    child: const NavBar(),
                  ),
                  // Vertical divider between sidebar and main content
                  Container(
                    width: 1,
                    height: double.infinity,
                    color: context.color.onTertiary.withOpacity(.3),
                  ),
                ],
                // Main content area
                Expanded(
                  child: Scaffold(
                    appBar: const CustomAppBar(),
                    body: child,
                  ),
                ),
              ],
            ),
          ),
          // Mobile sidebar with slide animation
          if (isMobile)
            AnimatedPositioned(
              key: const ValueKey('mobile_navbar'),
              top: 56,
              bottom: 0,
              duration: const Duration(milliseconds: 200),
              width: AppConstants.sidebarExpandedWidth,
              left: isExpanded ? 0 : -AppConstants.sidebarExpandedWidth,
              child: Container(
                color: context.color.tertiary,
                child: const NavBar(),
              ),
            ),
        ],
      ),
    );
  }
}
