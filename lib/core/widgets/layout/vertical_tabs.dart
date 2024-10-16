import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:coach_app/core/theme/app_colors.dart';
import 'package:coach_app/core/theme/app_text_style.dart';
import 'package:coach_app/shared/extensions/context.dart';

/// A widget that displays vertical tabs on desktop and expansion tiles on mobile.
class VerticalTabs extends StatefulWidget {
  /// The list of tabs to display.
  final List<VerticalTab> tabs;

  const VerticalTabs({
    super.key,
    required this.tabs,
  });

  @override
  State<VerticalTabs> createState() => _VerticalTabsState();
}

class _VerticalTabsState extends State<VerticalTabs> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return constraints.maxWidth < 540
          ? _buildMobileLayout()
          : _buildDesktopLayout();
    });
  }

  Widget _buildDesktopLayout() {
    final tab = widget.tabs[_selectedIndex];
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 230,
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: widget.tabs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) => VerticalTabItem(
              tab: widget.tabs[index],
              isSelected: index == _selectedIndex,
              onTap: () {
                setState(() => _selectedIndex = index);
                widget.tabs[index].onSelect?.call();
              },
            ),
          ),
        ),
        const SizedBox(width: 32),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      tab.title,
                      style: AppTextStyle.primary18b,
                    ),
                  ),
                  if (tab.action != null) ...[
                    const SizedBox(width: 12),
                    tab.action!,
                  ]
                ],
              ),
              const Divider(
                color: AppColors.grey300,
                thickness: 1,
                height: 32,
              ),
              Expanded(
                child: Container(
                  constraints: tab.contentConstraints == double.infinity
                      ? null
                      : BoxConstraints(maxWidth: tab.contentConstraints),
                  child: _buildTabContent(context, tab),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildMobileLayout() {
    return ListView.builder(
      itemCount: widget.tabs.length,
      itemBuilder: (context, index) {
        final tab = widget.tabs[index];
        final foregroundColor = _selectedIndex == index
            ? context.color.onSurface
            : AppColors.grey200;

        return ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 12),
          backgroundColor: AppColors.grey100.withOpacity(.2),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          childrenPadding: const EdgeInsets.symmetric(horizontal: 12),
          onExpansionChanged: (value) {
            if (value) tab.onSelect?.call();
          },
          title: Row(
            children: [
              SvgPicture.asset(
                'assets/icons/check-mark-circle-outlined.svg',
                colorFilter: ColorFilter.mode(
                  foregroundColor,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                tab.title,
                style:
                    AppTextStyle.primary14r.copyWith(color: foregroundColor),
              ),
            ],
          ),
          children: [
            if (tab.action != null) ...[
              tab.action!,
            ],
            _buildTabContent(context, tab),
          ],
        );
      },
    );
  }

  Widget _buildTabContent(BuildContext context, VerticalTab tab) {
    if (tab.isContentScrollable) {
      return context.isMobile
          ? Container(
              height: 360,
              padding: const EdgeInsets.only(bottom: 12, top: 4),
              child: tab.content,
            )
          : tab.content;
    } else {
      return SingleChildScrollView(
        child: tab.content,
      );
    }
  }
}

/// A widget representing a single vertical tab item.
class VerticalTabItem extends StatelessWidget {
  final VerticalTab tab;
  final bool isSelected;
  final VoidCallback onTap;

  const VerticalTabItem({
    super.key,
    required this.tab,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final foregroundColor =
        isSelected ? context.color.onSurface : context.color.onSurface;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 44,
          decoration: BoxDecoration(
            color: isSelected ? context.color.tertiary : null,
          ),
          child: Row(
            children: [
              if (isSelected)
                Container(
                  width: 6,
                  height: 44,
                  color: AppColors.primaryGreen,
                )
              else
                const SizedBox(width: 6),
              if (tab.iconPath != null)
                Padding(
                  padding: const EdgeInsets.only(left: 14, right: 10),
                  child: SvgPicture.asset(
                    tab.iconPath!,
                    colorFilter: tab.paintIcon
                        ? ColorFilter.mode(foregroundColor, BlendMode.srcIn)
                        : null,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  tab.title,
                  style:
                      AppTextStyle.primary14r.copyWith(color: foregroundColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A class representing the data for a vertical tab.
class VerticalTab {
  final String title;

  final String? iconPath;
  final bool paintIcon;

  final Widget content;
  final bool isContentScrollable;
  final double contentConstraints;

  final VoidCallback? onSelect;
  final Widget? action;

  VerticalTab({
    required this.title,
    this.iconPath,
    required this.content,
    this.paintIcon = false,
    this.isContentScrollable = false,
    this.contentConstraints = 586,
    this.onSelect,
    this.action,
  });
}
