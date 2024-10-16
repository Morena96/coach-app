import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import 'package:coach_app/core/router/navbar_item.dart';
import 'package:coach_app/core/theme/app_text_style.dart';
import 'package:coach_app/core/widgets/layout/navbar_item_tile.dart';
import 'package:coach_app/core/widgets/layout/navbar_logo.dart';
import 'package:coach_app/l10n.dart';
import 'package:coach_app/shared/extensions/context.dart';
import 'package:coach_app/shared/providers/navbar_state_provider.dart';

/// A widget that represents the navigation bar of the application.
///
/// This widget displays the logo, navigation items, and an expand/collapse button.
/// It adapts its layout based on the current state of the navigation bar.
class NavBar extends ConsumerWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navbarState = ref.watch(navbarStateProvider);
    final isExpanded = navbarState.expanded;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 25),
        NavbarLogo(isExpanded: isExpanded),
        const SizedBox(height: 20),
        Expanded(
          child: ListView(
            physics: const ClampingScrollPhysics(),
            children: [
              _sectionTitle(context.l10n.overview, isExpanded),
              NavbarItemTile(
                item: NavbarItem.dashboard,
                navbarState: navbarState,
              ),
              NavbarItemTile(
                item: NavbarItem.data,
                navbarState: navbarState,
                disabled: true,
              ),
              _sectionTitle(context.l10n.community, isExpanded),
              NavbarItemTile(
                item: NavbarItem.groups,
                navbarState: navbarState,
              ),
              NavbarItemTile(
                key: const Key('navigation_athletes'),
                item: NavbarItem.athletes,
                navbarState: navbarState,
              ),
              NavbarItemTile(
                item: NavbarItem.reports,
                navbarState: navbarState,
                disabled: true,
              ),
              _sectionTitle(context.l10n.session, isExpanded),
              NavbarItemTile(
                item: NavbarItem.liveSession,
                navbarState: navbarState,
                disabled: true,
              ),
              NavbarItemTile(
                item: NavbarItem.sessions,
                navbarState: navbarState,
              ),
              NavbarItemTile(
                item: NavbarItem.videoExport,
                navbarState: navbarState,
                disabled: true,
              ),
              _sectionTitle(context.l10n.admin, isExpanded),
              NavbarItemTile(
                item: NavbarItem.alerts,
                navbarState: navbarState,
                disabled: true,
              ),
              NavbarItemTile(
                item: NavbarItem.settings,
                navbarState: navbarState,
              ),
            ],
          ),
        ),
        // Expand/collapse button
        Padding(
          padding: const EdgeInsets.only(left: 28, bottom: 20),
          child: IconButton(
            onPressed: () => ref.read(navbarStateProvider.notifier).state =
                navbarState.copyWith(expanded: !navbarState.expanded),
            icon: SvgPicture.asset(
              isExpanded
                  ? 'assets/icons/arrow-left.svg'
                  : 'assets/icons/arrow-right.svg',
              colorFilter: ColorFilter.mode(
                context.color.onTertiary,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Creates a section title widget for the navigation bar.
  ///
  /// This widget adapts its layout based on whether the navigation bar is expanded.
  Widget _sectionTitle(String title, bool isExpanded) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.fromLTRB(isExpanded ? 40 : 0, 20, 0, 4),
      child: AnimatedAlign(
        duration: const Duration(milliseconds: 200),
        alignment: isExpanded ? Alignment.centerLeft : Alignment.center,
        child: Text(
          title,
          style: AppTextStyle.primary12r,
        ),
      ),
    );
  }
}
