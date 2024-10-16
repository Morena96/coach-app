import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:coach_app/core/widgets/table_header_col.dart';
import 'package:coach_app/l10n.dart';
import 'package:coach_app/shared/extensions/context.dart';

class GroupMemberTableHeader extends ConsumerStatefulWidget {
  const GroupMemberTableHeader({super.key});

  @override
  ConsumerState<GroupMemberTableHeader> createState() =>
      _GroupMemberTableHeaderState();
}

class _GroupMemberTableHeaderState
    extends ConsumerState<GroupMemberTableHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      padding: const EdgeInsets.fromLTRB(70, 16, 16, 8),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: TableHeaderCol(
              title: context.l10n.name,
            ),
          ),
          if (!context.isMobile) ...[
            const SizedBox(width: 20),
            Expanded(
              flex: 2,
              child: TableHeaderCol(
                title: context.l10n.role,
              ),
            ),
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
