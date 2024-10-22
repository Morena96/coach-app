import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:coach_app/core/theme/app_colors.dart';
import 'package:coach_app/core/widgets/app_tabs.dart';
import 'package:coach_app/core/widgets/layout/bread_crumb_provider.dart';
import 'package:coach_app/core/widgets/layout/page_header.dart';
import 'package:coach_app/core/widgets/layout/page_layout.dart';
import 'package:coach_app/core/widgets/square_icon_button.dart';
import 'package:coach_app/features/athletes/presentation/providers/athlete_view_model_provider.dart';
import 'package:coach_app/features/athletes/presentation/widgets/athlete_profile_header.dart';
import 'package:coach_app/features/athletes/presentation/widgets/athlete_profile_profile_tab.dart';
import 'package:coach_app/features/athletes/presentation/widgets/athlete_profile_summary_card.dart';
import 'package:coach_app/features/athletes/presentation/widgets/athlete_table_item.dart';
import 'package:coach_app/l10n.dart';

/// A page for viewing an athlete's information.
class AthleteProfilePage extends ConsumerWidget {
  const AthleteProfilePage({
    super.key,
    required this.athleteId,
    required this.athleteName,
  });

  final String athleteId;
  final String athleteName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final athleteState = ref.watch(athleteViewModelProvider(athleteId));

    return BreadcrumbProvider(
      customTitles: {'/athletes/$athleteId': athleteName},
      child: PageLayout(
        header: athleteState.maybeWhen(
          data: (athlete) => PageHeader(
            titleWidget: AthleteProfileHeader(athlete: athlete),
            actions: [
              const SizedBox(width: 12),
              SquareIconButton(
                size: 38,
                iconPath: 'assets/icons/edit.svg',
                onPressed: () => context.push(
                  '/athletes/${athlete.id}/edit',
                  extra: athlete,
                ),
              ),
              const SizedBox(width: 12),
              SquareIconButton(
                size: 38,
                iconPath: athlete.archived
                    ? 'assets/icons/restore.svg'
                    : 'assets/icons/trash.svg',
                onPressed: () => deleteOrRestoreAthlete(context, athlete, ref,
                    onSuccess: () => context.pop()),
                iconSize: athlete.archived ? 16 : null,
                iconColor: AppColors.black,
                backgroundColor: AppColors.lightRed,
              ),
            ],
            subtitle: AthleteProfileSummaryCard(athlete: athlete),
          ),
          orElse: () => null,
        ),
        child: athleteState.when(
          data: (athlete) => AppTabs(
            tabs: const ['Profile', 'Statistics'],
            tabContents: [
              AthleteProfileProfileTab(
                athleteId: athleteId,
              ),
              const Center(child: Text('Statistics')),
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
