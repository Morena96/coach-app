import 'package:coach_app/core/router/navbar_item.dart';
import 'package:coach_app/shared/extensions/context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import 'package:coach_app/core/theme/app_colors.dart';
import 'package:coach_app/core/theme/app_text_style.dart';
import 'package:coach_app/shared/providers/navbar_state_provider.dart';

/// A widget that represents a single item in the navigation bar.
///
/// This widget is responsible for rendering a clickable tile in the navigation bar,
/// handling hover states, and responding to user interactions.
class NavbarItemTile extends ConsumerStatefulWidget {
  const NavbarItemTile({
    super.key,
    required this.item,
    required this.navbarState,
    this.disabled = false,
  });

  /// The navigation item to be displayed.
  final NavbarItem item;

  /// The current state of the navigation bar.
  final NavbarState navbarState;

  final bool disabled;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SidebarItemWidgetState();
}

class _SidebarItemWidgetState extends ConsumerState<NavbarItemTile> {
  /// Tracks whether the mouse is currently hovering over the tile.
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isExpanded = widget.navbarState.expanded;
    final isSelected = widget.navbarState.selectedItem == widget.item.id;
    final themeColor = context.color;

    return IgnorePointer(
      ignoring: widget.disabled,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: InkWell(
          splashColor: AppColors.primaryGreen.withOpacity(.1),
          hoverColor: themeColor.onSurface.withOpacity(.05),
          onTap: () {
            // Update the selected item in the navbar state
            ref.read(navbarStateProvider.notifier).state =
                ref.read(navbarStateProvider.notifier).state.copyWith(
                      selectedItem: widget.item.id,
                      expanded: context.isMobile ? false : null,
                    );
            // Navigate to the selected item's route
            context.go(widget.item.route.path);
          },
          child: Container(
            height: 56,
            width: 300,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
            color: isSelected ? AppColors.primaryGreen.withOpacity(.14) : null,
            child: Stack(
              children: [
                // Display the appropriate icon based on hover and selection state
                SvgPicture.asset(
                  _isHovered || isSelected
                      ? 'assets/icons/navbar/${widget.item.id}-active.svg'
                      : 'assets/icons/navbar/${widget.item.id}.svg',
                  colorFilter: _isHovered || isSelected
                      ? null
                      : ColorFilter.mode(
                          themeColor.onTertiary.withOpacity(.5), BlendMode.srcIn),
                ),
                // Display the item title when the navbar is expanded
                if (isExpanded) ...[
                  Positioned(
                    top: 6,
                    left: 34,
                    child: Text(
                      widget.item.title(context),
                      style: AppTextStyle.primary14r.copyWith(
                        color: _isHovered || isSelected
                            ? themeColor.onSurface
                            : themeColor.onTertiary.withOpacity(.5),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
