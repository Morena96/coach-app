import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import 'package:coach_app/core/router/routes.dart';
import 'package:coach_app/core/theme/app_colors.dart';
import 'package:coach_app/core/theme/app_text_style.dart';
import 'package:coach_app/core/widgets/app_dialog.dart';
import 'package:coach_app/core/widgets/avatar_image.dart';
import 'package:coach_app/core/widgets/blurry_toast.dart';
import 'package:coach_app/features/athletes/presentation/models/athlete_view.dart';
import 'package:coach_app/features/athletes/presentation/models/sport_view.dart';
import 'package:coach_app/features/athletes/presentation/providers/athletes_view_model_provider.dart';
import 'package:coach_app/features/athletes/presentation/widgets/archived_chip.dart';
import 'package:coach_app/l10n.dart';
import 'package:coach_app/shared/extensions/context.dart';

/// Displays a single athlete's information in the table.
class AthleteTableItem extends StatelessWidget {
  final AthleteView athlete;

  const AthleteTableItem({
    super.key,
    required this.athlete,
  });

  @override
  Widget build(BuildContext context) {
    return context.isMobile
        ? AthleteMobileTableItem(athlete: athlete)
        : AthleteDesktopTableItem(athlete: athlete);
  }
}

class AthleteDesktopTableItem extends StatelessWidget {
  const AthleteDesktopTableItem({
    super.key,
    required this.athlete,
  });

  final AthleteView athlete;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.pushNamed(
        Routes.athleteDetails.name,
        pathParameters: {'id': athlete.id},
        extra: {'athleteName': athlete.name},
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30, 10, 16, 10),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: AthleteTableItemAvatarAndName(athlete: athlete),
            ),
            const SizedBox(width: 20),
            AthleteTableItemSports(
              sports: athlete.sports ?? [],
            ),
            const SizedBox(width: 20),
            AthleteDeleteButton(athlete: athlete)
          ],
        ),
      ),
    );
  }
}

class AthleteMobileTableItem extends StatelessWidget {
  const AthleteMobileTableItem({
    super.key,
    required this.athlete,
  });

  final AthleteView athlete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 2, 20, 2),
      child: ExpansionTile(
        key: ValueKey(athlete.id),
        title: AthleteTableItemAvatarAndName(athlete: athlete),
        childrenPadding: const EdgeInsets.symmetric(vertical: 10),
        tilePadding: EdgeInsets.zero,
        children: [
          Row(children: [
            AthleteTableItemSports(
              sports: athlete.sports ?? [],
            ),
            AthleteDeleteButton(athlete: athlete),
          ]),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => context.pushNamed(
              Routes.athleteDetails.name,
              pathParameters: {'id': athlete.id},
              extra: {'athleteName': athlete.name},
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(context.l10n.viewAthleteDetails),
            ),
          )
        ],
      ),
    );
  }
}

class AthleteTableItemAvatarAndName extends StatelessWidget {
  const AthleteTableItemAvatarAndName({
    super.key,
    required this.athlete,
  });

  final AthleteView athlete;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AvatarImage(avatarPath: athlete.avatarPath, size: 44),
        const SizedBox(width: 9),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        athlete.name,
                        style: AppTextStyle.primary16b,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: SvgPicture.asset('assets/icons/verified-mark.svg'),
                  ),
                ],
              ),
              if (athlete.archived) const ArchivedChip(),
            ],
          ),
        ),
      ],
    );
  }
}

class AthleteTableItemSports extends StatelessWidget {
  const AthleteTableItemSports({
    super.key,
    required this.sports,
  });
  final List<SportView> sports;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Row(
          children: [
            if (context.isMobile)
              Text(
                '${context.l10n.sport}: ',
                style: AppTextStyle.secondary14r,
              ),
            if (sports.isEmpty)
              const Text('-', style: AppTextStyle.secondary14r)
            else
              Expanded(
                child: Text(
                  sports.map((sport) => sport.name).join(' ' * 3),
                  style: AppTextStyle.primary14r
                      .copyWith(color: AppColors.primaryGreen),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              )
          ],
        ),
      ),
    );
  }
}

class AthleteDeleteButton extends ConsumerWidget {
  const AthleteDeleteButton({
    super.key,
    required this.athlete,
  });

  final AthleteView athlete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: 60,
      alignment: Alignment.centerRight,
      child: IconButton(
        onPressed: () => deleteOrRestoreAthlete(context, athlete, ref),
        constraints: const BoxConstraints(),
        icon: athlete.archived
            ? Icon(CupertinoIcons.refresh_bold,
                color: context.color.onTertiary, size: 20)
            : SvgPicture.asset(
                'assets/icons/trash.svg',
              ),
      ),
    );
  }
}

/// Deletes or restores an athlete based on their current status.
///
/// Shows a confirmation dialog before performing the action.
/// Displays a toast message indicating the result of the operation.
void deleteOrRestoreAthlete(
  BuildContext context,
  AthleteView athlete,
  WidgetRef ref, {
  VoidCallback? onSuccess,
}) async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (_) => AthleteDeleteRestoreConfirmDialog(athlete: athlete),
  );

  if (confirm == true) {
    if (athlete.archived) {
      final success = await ref
          .read(athletesViewModelProvider.notifier)
          .restoreAthlete(athlete);
      showBlurryToast(
        context,
        success
            ? context.l10n.athleteRestored
            : context.l10n.failedToRestoreAthlete,
      );
      onSuccess?.call();
    } else {
      final success = await ref
          .read(athletesViewModelProvider.notifier)
          .deleteItem(athlete);
      showBlurryToast(
        context,
        success
            ? context.l10n.athleteArchived
            : context.l10n.failedToArchiveAthlete,
      );
      onSuccess?.call();
    }
  }
}

/// Confirmation dialog for deleting an athlete.
class AthleteDeleteRestoreConfirmDialog extends StatelessWidget {
  const AthleteDeleteRestoreConfirmDialog({
    super.key,
    required this.athlete,
  });

  final AthleteView athlete;

  @override
  Widget build(BuildContext context) {
    return AppConfirmDialog(
      content: athlete.archived
          ? context.l10n.restoreAthleteConfirmText(athlete.name)
          : context.l10n.archiveAthleteConfirmText(athlete.name),
      positiveLabel: athlete.archived
          ? context.l10n.restoreTheAthlete
          : context.l10n.archiveTheAthlete,
    );
  }
}
