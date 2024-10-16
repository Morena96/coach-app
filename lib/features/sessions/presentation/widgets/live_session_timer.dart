import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:coach_app/core/theme/app_colors.dart';
import 'package:coach_app/core/theme/app_text_style.dart';

/// A widget that displays a live session time with a cloud check icon.
class LiveSessionTimer extends StatelessWidget {
  /// The total number of seconds elapsed in the session.
  final int seconds;

  const LiveSessionTimer({super.key, required this.seconds});

  @override
  Widget build(BuildContext context) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final remainingSeconds = seconds % 60;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.additionalBlack)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/icons/synced.svg',
          ),
          const SizedBox(width: 8),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              '${hours.toString().padLeft(2, '0')}'
              ':${minutes.toString().padLeft(2, '0')}'
              ':${remainingSeconds.toString().padLeft(2, '0')}',
              style: AppTextStyle.primary16b,
            ),
          ),
        ],
      ),
    );
  }
}
