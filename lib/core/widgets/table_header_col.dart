import 'package:domain/features/shared/value_objects/sort_order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:coach_app/core/theme/app_text_style.dart';
import 'package:coach_app/shared/extensions/context.dart';

/// A widget for table header columns, optionally sortable.
class TableHeaderCol extends StatelessWidget {
  final String title;
  final VoidCallback? onSort;
  final SortOrder? sortOrder;

  /// Creates a TableHeaderCol.
  /// If [onSort] is provided, the column becomes sortable.
  /// [sortOrder] indicates the current sort order for this column.
  const TableHeaderCol({
    super.key,
    required this.title,
    this.onSort,
    this.sortOrder,
  });

  @override
  Widget build(BuildContext context) {
    final color = context.color.onTertiary.withOpacity(.5);
    final text = Text(
      title,
      style: AppTextStyle.secondary14r.copyWith(color: color),
    );

    Widget? sortIcon;
    if (sortOrder != null) {
      sortIcon = Icon(
        sortOrder == SortOrder.ascending
            ? Icons.arrow_drop_up
            : Icons.arrow_drop_down,
        color: color,
      );
    } else if (onSort != null) {
      sortIcon = SvgPicture.asset(
        'assets/icons/table-header-sort.svg',
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      );
    }

    // Return plain text if not sortable, otherwise wrap in InkWell with sort icon
    return onSort == null
        ? text
        : InkWell(
            onTap: onSort,
            child: Row(
              children: [
                Flexible(child: text),
                if (sortIcon != null) ...[
                  const SizedBox(width: 4),
                  sortIcon,
                ],
              ],
            ),
          );
  }
}
