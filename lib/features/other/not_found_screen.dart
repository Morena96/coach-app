import 'package:coach_app/l10n.dart';
import 'package:coach_app/shared/extensions/context.dart';
import 'package:flutter/material.dart';

/// A widget that displays a 404 Not Found error screen.
class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          context.l10n.notFound,
          style: context.textTheme.headlineLarge,
        ),
      ),
    );
  }
}
