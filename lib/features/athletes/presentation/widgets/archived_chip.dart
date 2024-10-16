import 'package:flutter/material.dart';

import 'package:coach_app/core/theme/app_colors.dart';
import 'package:coach_app/core/theme/app_text_style.dart';
import 'package:coach_app/l10n.dart';

class ArchivedChip extends StatelessWidget {
  const ArchivedChip({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightRed),
      ),
      child: Text(
        context.l10n.archived,
        style: AppTextStyle.primary10r,
      ),
    );
  }
}
