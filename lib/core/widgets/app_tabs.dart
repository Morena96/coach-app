import 'package:coach_app/core/theme/app_colors.dart';
import 'package:coach_app/core/theme/app_text_style.dart';
import 'package:coach_app/shared/extensions/context.dart';
import 'package:flutter/material.dart';

/// A wrapper widget for TabBar and TabBarView that uses the app's theme.
/// The TabBar shrinks to fit its content and has no gap before the first tab, even when scrollable.
class AppTabs extends StatelessWidget {
  final List<String> tabs;
  final List<Widget> tabContents;
  final bool isScrollable;
  final Widget? action;
  final double distance;

  const AppTabs({
    super.key,
    required this.tabs,
    required this.tabContents,
    this.isScrollable = true,
    this.action,
    this.distance = 0,
  }) : assert(tabs.length == tabContents.length,
            'Tabs and contents must have the same length');

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        tabBarTheme: TabBarTheme(
          indicator: ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(26),
            ),
            color: AppColors.primaryGreen,
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          labelStyle: AppTextStyle.primary14b,
          unselectedLabelStyle: AppTextStyle.primary14r,
          labelColor: AppColors.black,
          unselectedLabelColor: context.color.onSurface,
          dividerColor: Colors.transparent,
          overlayColor: WidgetStateProperty.all(Colors.transparent),
        ),
      ),
      child: DefaultTabController(
        length: tabs.length,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Container(
                    height: 46,
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.3),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(21), // 24 - 3 for padding
                      child: TabBar(
                        isScrollable: isScrollable,
                        tabs: tabs.map((tab) => Tab(text: tab)).toList(),
                        labelPadding: EdgeInsets.symmetric(
                            horizontal: context.isDesktop ? 32 : 20),
                        splashFactory: NoSplash.splashFactory,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(21),
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        tabAlignment: isScrollable
                            ? TabAlignment.start
                            : TabAlignment.fill,
                      ),
                    ),
                  ),
                ),
                if (action != null) ...[const SizedBox(width: 12), action!],
              ],
            ),
            SizedBox(height: distance),
            Expanded(
              child: TabBarView(
                children: tabContents,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
