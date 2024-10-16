import 'package:coach_app/shared/extensions/context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:coach_app/core/theme/app_text_style.dart';
import 'package:coach_app/core/widgets/avatar_image.dart';
import 'package:coach_app/features/athletes/presentation/models/athlete_view.dart';
import 'package:coach_app/features/athletes/presentation/widgets/archived_chip.dart';
import 'package:coach_app/l10n.dart';

/// Displays the header of an athlete view, including avatar, name, and status.
class AthleteViewHeader extends StatelessWidget {
  /// Creates an [AthleteViewHeader] widget.
  const AthleteViewHeader({
    super.key,
    required this.athlete,
  });

  /// The athlete data to display.
  final AthleteView athlete;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Row(
        children: [
          /// Displays the athlete's avatar image.
          AvatarImage(
            avatarPath: athlete.avatarPath,
            size: context.isMobile ? 40 : 66,
          ),
          const SizedBox(width: 16),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 6),

                        /// Displays the athlete's name with responsive styling.
                        child: Text(
                          athlete.name,
                          style: context.isMobile
                              ? AppTextStyle.primary18b
                              : AppTextStyle.primary26b,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Padding(
                      padding: const EdgeInsets.only(top: 2),

                      /// Displays a verified mark icon.
                      child: SvgPicture.asset(
                        'assets/icons/verified-mark.svg',
                        width: 24,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    /// Displays the 'athlete' label.
                    Text(context.l10n.athlete),
                    if (athlete.archived) ...[
                      const SizedBox(width: 12),

                      /// Displays an archived chip if the athlete is archived.
                      const ArchivedChip(),
                    ]
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
