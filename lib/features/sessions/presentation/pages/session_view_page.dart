import 'package:coach_app/features/athletes/presentation/models/group_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:coach_app/core/theme/app_colors.dart';
import 'package:coach_app/core/theme/app_text_style.dart';
import 'package:coach_app/core/widgets/app_tabs.dart';
import 'package:coach_app/core/widgets/layout/bread_crumb_provider.dart';
import 'package:coach_app/core/widgets/layout/page_header.dart';
import 'package:coach_app/core/widgets/layout/page_layout.dart';
import 'package:coach_app/core/widgets/square_icon_button.dart';
import 'package:coach_app/features/sessions/presentation/models/session_view.dart';
import 'package:coach_app/features/sessions/presentation/providers/session_view_model_provider.dart';
import 'package:coach_app/l10n.dart';
import 'package:coach_app/shared/extensions/context.dart';

/// Displays detailed view of a specific session
class SessionViewPage extends ConsumerWidget {
  /// Creates a SessionViewPage
  const SessionViewPage({
    super.key,
    required this.session,
    this.group,
  });

  /// The session to be displayed
  final SessionView session;
  final GroupView? group;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// Watches the state of the session view model
    final state = ref.watch(sessionViewModelProvider(session.id));

    return BreadcrumbProvider(
      customTitles: {
        '/sessions/${session.id}': session.title,
        if (group != null) 'groups/${group!.id}': group!.name,
        if (group != null) 'groups/${group!.id}/${session.id}': session.title,
      },
      child: PageLayout(
        /// Builds the header based on the session state
        header: state.maybeWhen(
          data: (session) => PageHeader(
            titleWidget: Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  session.title,
                  style: context.isMobile
                      ? AppTextStyle.primary18b
                      : AppTextStyle.primary26b,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            actions: [
              const SizedBox(width: 12),
              SquareIconButton(
                size: 38,
                iconPath: 'assets/icons/edit.svg',
                onPressed: () {},
              ),
              const SizedBox(width: 12),
              SquareIconButton(
                size: 38,
                iconPath: 'assets/icons/trash.svg',
                onPressed: () {},
                iconColor: AppColors.black,
                backgroundColor: AppColors.lightRed,
              ),
            ],
          ),
          orElse: () => null,
        ),

        /// Builds the main content based on the session state
        child: state.when(
          data: (session) => AppTabs(
            tabs: const ['Statistics', 'Map View'],
            tabContents: const [
              Center(child: Text('Statistics')),
              Center(child: Text('Map View')),
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(
            child: Text(context.l10n.errorText(error)),
          ),
        ),
      ),
    );
  }
}
