import 'package:coach_app/l10n.dart';
import 'package:flutter/material.dart';

/// A widget for displaying error messages with an optional retry button.
class ErrorScreen extends StatelessWidget {
  final String error;
  final VoidCallback? onRetry;

  /// Creates an ErrorScreen.
  /// If [onRetry] is provided, a retry button will be displayed.
  const ErrorScreen({
    super.key,
    required this.error,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(80),
          child: Text(context.l10n.errorText(error)),
        ),
        if (onRetry != null) ...[
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onRetry,
            child: Text(context.l10n.retry),
          ),
        ]
      ],
    );
  }
}
