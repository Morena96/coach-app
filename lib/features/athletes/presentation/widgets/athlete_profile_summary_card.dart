import 'package:flutter/material.dart';

import 'package:coach_app/core/widgets/primary_button.dart';
import 'package:coach_app/core/widgets/sport_chip.dart';
import 'package:coach_app/features/athletes/presentation/models/athlete_view.dart';
import 'package:coach_app/features/athletes/presentation/widgets/athlete_profile_add_to_group_dialog.dart';
import 'package:coach_app/l10n.dart';
import 'package:coach_app/shared/extensions/context.dart';

class AthleteProfileSummaryCard extends StatelessWidget {
  const AthleteProfileSummaryCard({
    super.key,
    required this.athlete,
  });
  final AthleteView athlete;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      decoration: BoxDecoration(
        color: context.color.tertiary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: (athlete.sports ?? [])
                  .map((sport) => SportChip(sport: sport))
                  .toList(),
            ),
          ),
          const SizedBox(width: 20),
          PrimaryButton.add(
            label: context.l10n.addToTheGroup,
            onPressed: () => showDialog(
              context: context,
              builder: (_) => AthleteProfileAddToGroupDialog(athlete: athlete),
            ),
          )
        ],
      ),
    );
  }
}
