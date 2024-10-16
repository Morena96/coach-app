import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import 'package:coach_app/core/router/routes.dart';
import 'package:coach_app/core/theme/app_colors.dart';
import 'package:coach_app/core/theme/app_text_style.dart';
import 'package:coach_app/core/widgets/layout/bread_crumb_provider.dart';
import 'package:coach_app/features/shared/widgets/bread_crumb_item.dart';
import 'package:coach_app/shared/extensions/context.dart';
import 'package:coach_app/shared/extensions/go_router.dart';
import 'package:coach_app/shared/extensions/string.dart';

/// A widget that displays breadcrumbs based on the current route.
///
/// This widget creates a row of clickable breadcrumbs that represent
/// the current navigation path. It uses the GoRouter to determine
/// the current location and builds the breadcrumbs accordingly.
class BreadCrumbles extends StatelessWidget {
  const BreadCrumbles({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final breadcrumbs = _buildBreadcrumbs(context, GoRouter.of(context));
    if (breadcrumbs.length < 2) return const SizedBox(height: 16);

    return Container(
      height: 30,
      padding: context.pagePadding(top: 14, bottom: 0),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          for (var crumb in breadcrumbs) ...[
            InkWell(
              onTap: crumb.onTap,
              child: Text(
                crumb.label,
                style: AppTextStyle.secondary12r.copyWith(
                  color: crumb.onTap != null ? AppColors.grey200 : null,
                ),
              ),
            ),
            if (crumb != breadcrumbs.last)
              Padding(
                padding: const EdgeInsets.only(bottom: 3, left: 6, right: 6),
                child: SvgPicture.asset(
                  'assets/icons/arrow-right.svg',
                  width: 20,
                  colorFilter: const ColorFilter.mode(
                      AppColors.grey200, BlendMode.srcIn),
                ),
              ),
          ]
        ],
      ),
    );
  }

  /// Builds a list of [BreadcrumbItem]s based on the current route.
  ///
  /// This method parses the current location from the router and creates
  /// a breadcrumb item for each segment of the path.
  List<BreadcrumbItem> _buildBreadcrumbs(
      BuildContext context, GoRouter router) {
    final breadcrumbs = <BreadcrumbItem>[];
    final customTitles = BreadcrumbProvider.of(context)?.customTitles ?? {};

    final routePaths =
        router.location.split('/').where((path) => path.isNotEmpty).toList();
    var currentPath = '';

    for (var i = 0; i < routePaths.length; i++) {
      final path = routePaths[i];
      currentPath += '/$path';
      final isLast = i == routePaths.length - 1;

      final label = customTitles[currentPath] ??
          customTitles[currentPath.substring(1)] ??
          _getBreadcrumbLabel(path);

      // Calculate the number of pops required
      final popsRequired = routePaths.length - i - 1;

      final onTap = isLast
          ? null
          : () {
              for (var j = 0; j < popsRequired; j++) {
                context.pop();
              }
            };

      breadcrumbs.add(BreadcrumbItem(
        label: label,
        onTap: onTap,
      ));
    }
    return breadcrumbs;
  }

  /// Gets the display label for a breadcrumb based on the path segment.
  ///
  /// This method attempts to match the path segment to a predefined route
  /// and returns a formatted label. If no match is found, it capitalizes
  /// the path segment.
  String _getBreadcrumbLabel(String pathSegment) {
    for (var route in Routes.values) {
      if (route.path.replaceAll('/', '') == pathSegment) {
        return route.name.convertCamelCaseToSpacedUpperCase();
      }
    }
    return pathSegment.capitalize();
  }
}
