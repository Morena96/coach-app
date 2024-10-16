import 'package:flutter/material.dart';

import 'package:coach_app/core/widgets/sport_chip.dart';
import 'package:coach_app/features/athletes/presentation/models/sport_view.dart';
import 'package:coach_app/shared/extensions/context.dart';

class AthleteProfileHeader extends StatelessWidget {
  const AthleteProfileHeader({
    super.key,
    required this.sports,
  });
  final List<SportView> sports;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      decoration: BoxDecoration(
        color: context.color.tertiary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: sports.map((sport) => SportChip(sport: sport)).toList(),
      ),
    );
  }
}
