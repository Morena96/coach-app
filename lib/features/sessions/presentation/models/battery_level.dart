import 'package:coach_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

enum BatteryLevel {
  high(AppColors.additionalGreen),
  medium(AppColors.additionalYellow),
  low(AppColors.additionalOrange),
  bad(AppColors.additionalRed),
  none(AppColors.grey100);

  final Color color;
  const BatteryLevel(this.color);
}
