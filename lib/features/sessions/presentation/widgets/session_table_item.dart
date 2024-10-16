import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import 'package:coach_app/core/router/routes.dart';
import 'package:coach_app/core/theme/app_text_style.dart';
import 'package:coach_app/core/widgets/app_dialog.dart';
import 'package:coach_app/core/widgets/blurry_toast.dart';
import 'package:coach_app/features/athletes/presentation/models/group_view.dart';
import 'package:coach_app/features/sessions/presentation/models/session_view.dart';
import 'package:coach_app/features/sessions/presentation/models/session_with_group_view.dart';
import 'package:coach_app/features/sessions/presentation/providers/sessions_view_model_provider.dart';
import 'package:coach_app/l10n.dart';
import 'package:coach_app/shared/extensions/context.dart';
import 'package:coach_app/shared/extensions/date_time.dart';
import 'package:coach_app/shared/extensions/duration.dart';

/// Represents a table item for displaying session information.
/// Chooses between mobile and desktop layouts based on the device.
class SessionTableItem extends StatelessWidget {
  final SessionView session;
  final String? groupId;

  const SessionTableItem({
    super.key,
    required this.session,
    this.groupId,
  });

  @override
  Widget build(BuildContext context) {
    return !context.isDesktop
        ? SessionMobileTableItem(session: session, groupId: groupId)
        : SessionDesktopTableItem(session: session, groupId: groupId);
  }
}

/// Displays session information in a row format for desktop layouts.
class SessionDesktopTableItem extends StatelessWidget {
  const SessionDesktopTableItem({
    super.key,
    required this.session,
    this.groupId,
  });

  final SessionView session;
  final String? groupId;

  @override
  Widget build(BuildContext context) {
    final date = session.startTime.formatForLocale(context);
    final duration = session.duration.toHHMMSS();
    return InkWell(
      onTap: () => groupId == null
          ? context.pushNamed(
              Routes.sessionDetails.name,
              pathParameters: {'id': session.id},
              extra: session,
            )
          : context.pushNamed(
              Routes.groupSessionDetails.name,
              pathParameters: {'sessionId': session.id, 'id': groupId!},
              extra: SessionWithGroupView(
                session: session,
                group: GroupView(
                    id: groupId!,
                    name: session.assignedGroupName,
                    members: const []),
              ),
            ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30, 10, 16, 10),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Tooltip(
                message: session.title,
                child: Text(
                  session.title,
                  style: AppTextStyle.primary16b,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Tooltip(
                message: date,
                child: Text(
                  date,
                  style: AppTextStyle.primary16r,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Tooltip(
                message: duration,
                child: Text(
                  duration,
                  style: AppTextStyle.primary16r,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Tooltip(
                message: session.selectedAthletes.map((a) => a.name).join(', '),
                child: Text(
                  '${session.selectedAthletes.length} ${context.l10n.athletes}',
                  style: AppTextStyle.primary16r,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Tooltip(
                message: session.sport.name,
                child: Text(
                  session.sport.name,
                  style: AppTextStyle.primary16r,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              flex: 2,
              child: Tooltip(
                message: session.assignedGroupName,
                child: Text(
                  session.assignedGroupName,
                  style: AppTextStyle.primary16r,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const SizedBox(width: 20),
            SessionEditDeleteButton(session: session, groupId: groupId)
          ],
        ),
      ),
    );
  }
}

/// Displays session information in an expandable tile format for mobile layouts.
class SessionMobileTableItem extends StatelessWidget {
  const SessionMobileTableItem({
    super.key,
    required this.session,
    this.groupId,
  });

  final SessionView session;
  final String? groupId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 2, 20, 2),
      child: ExpansionTile(
        key: ValueKey(session.id),
        title: Text(
          session.title,
          style: AppTextStyle.primary16b,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        childrenPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        tilePadding: EdgeInsets.zero,
        children: [
          _buildInfoRow(
              context.l10n.date, session.startTime.formatForLocale(context)),
          _buildInfoRow(context.l10n.duration, session.duration.toHHMMSS()),
          _buildInfoRow(
              context.l10n.athletes, '${session.selectedAthletes.length}'),
          _buildInfoRow(context.l10n.group, session.assignedGroupName),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SessionEditDeleteButton(session: session, groupId: groupId),
            ],
          ),
          TextButton(
            onPressed: () => context.pushNamed(
              Routes.sessionDetails.name,
              pathParameters: {'id': session.id},
              extra: session,
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(context.l10n.viewSessionDetails),
            ),
          )
        ],
      ),
    );
  }

  /// Builds a row with a label and value for displaying session information.
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: AppTextStyle.primary14r.copyWith(color: Colors.grey),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: AppTextStyle.primary14r,
            ),
          ),
        ],
      ),
    );
  }
}

/// Displays edit and delete buttons for a session.
class SessionEditDeleteButton extends ConsumerWidget {
  const SessionEditDeleteButton({
    super.key,
    required this.session,
    this.groupId,
  });

  final SessionView session;
  final String? groupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: 80,
      child: Row(
        children: [
          Tooltip(
            message: context.l10n.editSession,
            child: IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(
                'assets/icons/pen.svg',
                width: 18,
              ),
            ),
          ),
          Tooltip(
            message: context.l10n.deleteSession,
            child: IconButton(
              onPressed: () =>
                  deleteSession(context, session, ref, groupId: groupId),
              icon: SvgPicture.asset(
                'assets/icons/trash.svg',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Shows a confirmation dialog for deleting a session.
void deleteSession(
  BuildContext context,
  SessionView session,
  WidgetRef ref, {
  VoidCallback? onSuccess,
  String? groupId,
}) async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (_) => SessionDeleteConfirmDialog(session: session),
  );

  if (confirm == true) {
    final success = await ref
        .read(sessionsViewModelProvider(groupId).notifier)
        .deleteItem(session);

    // Remove the session from sessions list page in case if user deletes from
    // group page's sessions tab
    if (groupId != null) {
      await ref
          .read(sessionsViewModelProvider(null).notifier)
          .deleteItem(session);
    }
    showBlurryToast(
      context,
      success ? context.l10n.deleteSession : context.l10n.failedToDeleteSession,
    );
    onSuccess?.call();
  }
}

/// Displays a confirmation dialog for session deletion.
class SessionDeleteConfirmDialog extends StatelessWidget {
  const SessionDeleteConfirmDialog({
    super.key,
    required this.session,
  });

  final SessionView session;

  @override
  Widget build(BuildContext context) {
    return AppConfirmDialog(
      content: context.l10n.deleteSessionConfirmText,
      positiveLabel: context.l10n.deleteTheSession,
    );
  }
}
