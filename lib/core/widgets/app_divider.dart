import 'package:coach_app/shared/extensions/context.dart';
import 'package:flutter/material.dart';

class AppDivider extends StatelessWidget {
  const AppDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: context.color.onSurface.withOpacity(.14),
    );
  }
}
