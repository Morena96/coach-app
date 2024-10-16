import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:coach_app/core/widgets/table_header_col.dart';
import 'package:coach_app/features/athletes/presentation/providers/athletes_view_model_provider.dart';
import 'package:coach_app/l10n.dart';
import 'package:coach_app/shared/extensions/context.dart';

/// Header for the athlete table, displaying column titles.
class AthleteTableHeader extends ConsumerStatefulWidget {
  const AthleteTableHeader({super.key});

  @override
  ConsumerState<AthleteTableHeader> createState() => _AthleteTableHeaderState();
}

class _AthleteTableHeaderState extends ConsumerState<AthleteTableHeader> {
  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(athletesViewModelProvider.notifier);
    final sortCriteria = viewModel.currentSort;

    return Container(
      key: ValueKey(sortCriteria.order),
      height: 54,
      padding: const EdgeInsets.fromLTRB(30, 8, 16, 8),
      child: Row(
        children: [
          // Name column
          Expanded(
            flex: 3,
            child: TableHeaderCol(
              title: context.l10n.name,
              onSort: () {
                ref.read(athletesViewModelProvider.notifier).updateSort('name');
                setState(() {});
              },
              sortOrder:
                  sortCriteria.field == 'name' ? sortCriteria.order : null,
            ),
          ),
          if (!context.isMobile) ...[
            const SizedBox(width: 20),
            Expanded(
              flex: 3,
              child: TableHeaderCol(
                title: context.l10n.sport,
              ),
            ),
            const SizedBox(width: 20),
            Container(
              width: 60,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 10),
              child: TableHeaderCol(
                title: context.l10n.action,
              ),
            )
          ],
        ],
      ),
    );
  }
}
