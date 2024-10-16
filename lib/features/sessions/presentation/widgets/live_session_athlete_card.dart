import 'package:coach_app/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:coach_app/core/theme/app_colors.dart';
import 'package:coach_app/core/theme/app_text_style.dart';
import 'package:coach_app/core/widgets/app_divider.dart';
import 'package:coach_app/core/widgets/avatar_image.dart';
import 'package:coach_app/features/athletes/presentation/models/athlete_view.dart';
import 'package:coach_app/features/sessions/presentation/models/battery_level.dart';
import 'package:coach_app/features/sessions/presentation/models/signal_quality.dart';

/// Displays a card with athlete information and performance stats for a live session.
class LiveSessionAthleteCard extends StatelessWidget {
  /// Creates a LiveSessionAthleteCard.
  ///
  /// [athlete] contains the athlete's information.
  /// [signalQuality] represents the quality of the GPS signal.
  /// [batteryLevel] represents the battery level of the athlete's device.
  const LiveSessionAthleteCard({
    super.key,
    required this.athlete,
    required this.signalQuality,
    required this.batteryLevel,
  });

  final AthleteView athlete;
  final SignalQuality signalQuality;
  final BatteryLevel batteryLevel;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.additionalBlack,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AvatarImage(avatarPath: athlete.avatarPath, size: 50),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      const Text(
                        'Pod_id',
                        style: AppTextStyle.secondary12r,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        athlete.name,
                        style: AppTextStyle.primary16b,
                      ),
                    ],
                  ),
                ),
                SvgPicture.asset(
                  'assets/icons/signal-quality.svg',
                  width: 20,
                  colorFilter: ColorFilter.mode(
                    signalQuality.color,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 16),
                SvgPicture.asset(
                  'assets/icons/battery-level.svg',
                  width: 20,
                  colorFilter: ColorFilter.mode(
                    batteryLevel.color,
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
          ),
          const AppDivider(),
          GridView.count(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.5,
            mainAxisSpacing: 6,
            crossAxisSpacing: 6,
            children: [
              StatCard(
                label: context.l10n.instantSpeed,
                value: '21,3',
                unit: context.l10n.mph,
              ),
              StatCard(
                label: context.l10n.maxSpeed,
                value: '22,5',
                unit: context.l10n.mph,
                isHighlighted: true,
              ),
              StatCard(
                label: context.l10n.sprintSpeed,
                value: '20,1',
                unit: context.l10n.mph,
              ),
              StatCard(
                label: context.l10n.totalDistance,
                value: '145',
                unit: context.l10n.yards,
              ),
              StatCard(
                label: context.l10n.sprintDistance,
                value: '72',
                unit: context.l10n.yards,
              ),
              StatCard(
                label: context.l10n.hsr,
                value: '93',
                unit: '',
              ),
              StatCard(
                label: context.l10n.dSession,
                value: '00:30',
                unit: '',
              ),
              StatCard(
                label: context.l10n.recoveryTime,
                value: '2:15',
                unit: context.l10n.min,
                isWarning: true,
              ),
              StatCard(
                label: context.l10n.acceleration,
                value: '-0,05',
                unit: context.l10n.fps,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Displays a single statistic card within the LiveSessionAthleteCard.
class StatCard extends StatelessWidget {
  /// Creates a StatCard.
  ///
  /// [label] is the name of the statistic.
  /// [value] is the numeric value of the statistic.
  /// [unit] is the unit of measurement for the statistic.
  /// [isHighlighted] indicates if the card should be highlighted (e.g., for best performance).
  /// [isWarning] indicates if the card should show a warning state.
  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
    this.isHighlighted = false,
    this.isWarning = false,
  });

  final String label;
  final String value;
  final String unit;
  final bool isHighlighted;
  final bool isWarning;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(.02),
        border: isHighlighted
            ? Border.all(color: AppColors.additionalGreen, width: .5)
            : isWarning
                ? Border.all(color: AppColors.additionalRed, width: .5)
                : null,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            label,
            style: AppTextStyle.secondary12r,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                value,
                style: AppTextStyle.primary18b,
              ),
              const SizedBox(width: 4),
              Text(
                unit,
                style: AppTextStyle.secondary12r,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
