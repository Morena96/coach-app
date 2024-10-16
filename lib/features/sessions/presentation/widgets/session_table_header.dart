import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:coach_app/core/widgets/table_header_col.dart';
import 'package:coach_app/features/sessions/presentation/providers/sessions_view_model_provider.dart';
import 'package:coach_app/l10n.dart';
import 'package:coach_app/shared/extensions/context.dart';

/// Displays the header for the session table, including sortable columns.
/// This widget is stateful to manage sorting state changes.
class SessionTableHeader extends ConsumerStatefulWidget {
  const SessionTableHeader({super.key});

  @override
  ConsumerState<SessionTableHeader> createState() => _SessionTableHeaderState();
}

class _SessionTableHeaderState extends ConsumerState<SessionTableHeader> {
  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(sessionsViewModelProvider(null).notifier);
    final sortCriteria = viewModel.currentSort;

    return Container(
      key: ValueKey(sortCriteria.order),
      height: 54,
      padding: const EdgeInsets.fromLTRB(30, 8, 16, 8),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: TableHeaderCol(
              title: context.l10n.name,
            ),
          ),
          if (context.isDesktop) ...[
            const SizedBox(width: 20),
            Expanded(
              child: TableHeaderCol(
                title: context.l10n.date,
                onSort: () {
                  ref
                      .read(sessionsViewModelProvider(null).notifier)
                      .updateSort('date');
                  setState(() {});
                },
                sortOrder:
                    sortCriteria.field == 'date' ? sortCriteria.order : null,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: TableHeaderCol(
                title: context.l10n.duration,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: TableHeaderCol(
                title: context.l10n.athletes,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: TableHeaderCol(
                title: context.l10n.sport,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              flex: 2,
              child: TableHeaderCol(
                title: context.l10n.group,
              ),
            ),
            const SizedBox(width: 20),
            Container(
              width: 80,
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
