import 'package:coach_app/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';

class FormLabel extends StatelessWidget {
  const FormLabel({
    super.key,
    required this.label,
    required this.child,
  });
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyle.primary16r,
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }
}
