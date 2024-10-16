import 'package:flutter/material.dart';

import 'package:coach_app/core/theme/app_colors.dart';
import 'package:coach_app/core/theme/app_text_style.dart';
import 'package:coach_app/features/athletes/presentation/models/sport_view.dart';

/// A chip widget that displays a sport name.
///
/// This widget creates a container with rounded corners and a border,
/// displaying the name of the sport inside.
class SportChip extends StatelessWidget {
  /// Creates a [SportChip].
  ///
  /// The [sport] parameter is required and represents the sport to be displayed.
  const SportChip({
    super.key,
    required this.sport,
  });

  /// The sport to be displayed in the chip.
  final SportView sport;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 6),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.grey300),
        borderRadius: BorderRadius.circular(19),
      ),
      child: Text(sport.name, style: AppTextStyle.primary14r),
    );
  }
}
