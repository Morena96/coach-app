import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:coach_app/core/theme/app_colors.dart';
import 'package:coach_app/core/theme/app_text_style.dart';
import 'package:coach_app/core/widgets/app_tabs.dart';
import 'package:coach_app/core/widgets/layout/bread_crumb_provider.dart';
import 'package:coach_app/core/widgets/layout/page_header.dart';
import 'package:coach_app/core/widgets/layout/page_layout.dart';
import 'package:coach_app/core/widgets/square_icon_button.dart';
import 'package:coach_app/features/athletes/presentation/models/group_view.dart';
import 'package:coach_app/features/sessions/presentation/models/session_view.dart';
import 'package:coach_app/features/sessions/presentation/providers/session_view_model_provider.dart';
import 'package:coach_app/features/sessions/presentation/widgets/edit_session_button.dart';
import 'package:coach_app/l10n.dart';
import 'package:coach_app/shared/extensions/context.dart';

/// Displays detailed view of a specific session
class SessionViewPage extends ConsumerStatefulWidget {
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
  ConsumerState<SessionViewPage> createState() => _SessionViewPageState();
}

class _SessionViewPageState extends ConsumerState<SessionViewPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    /// Watches the state of the session view model
    final state = ref.watch(sessionViewModelProvider(widget.session.id));

    return BreadcrumbProvider(
      customTitles: {
        '/sessions/${widget.session.id}': widget.session.title,
        if (widget.group != null)
          'groups/${widget.group!.id}': widget.group!.name,
        if (widget.group != null)
          'groups/${widget.group!.id}/${widget.session.id}': state.maybeWhen(
            data: (session) => session.title,
            orElse: () => widget.session.title,
          ),
      },
      child: Scaffold(
        key: _scaffoldKey,
        endDrawer: context.isDesktop
            ? state.maybeWhen(
                data: (session) => Drawer(
                  width: MediaQuery.of(context).size.width * 0.3,
                  backgroundColor: context.color.tertiary,
                  child: SafeArea(
                    child: EditSessionContent(session: session, ref: ref),
                  ),
                ),
                orElse: () => null,
              )
            : null,
        body: PageLayout(
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
                EditSessionButton(
                  session: session,
                  hasDrawer: true,
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(9),
                    child: SvgPicture.asset('assets/icons/edit.svg'),
                  ),
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
              tabs: [context.l10n.statistics, context.l10n.mapView],
              tabContents: [
                Center(child: Text(context.l10n.statistics)),
                Center(child: Text(context.l10n.mapView)),
              ],
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(
              child: Text(context.l10n.errorText(error)),
            ),
          ),
        ),
      ),
    );
  }
}
