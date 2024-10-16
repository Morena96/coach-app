import 'package:coach_app/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:coach_app/core/widgets/screens/initialized_app.dart';
import 'package:coach_app/core/widgets/screens/loading_screen.dart';
import 'package:coach_app/shared/providers/initialization_provider.dart';

class CoachApp extends ConsumerWidget {
  const CoachApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initializationState = ref.watch(initializationProvider);

    return initializationState.when(
      data: (_) => const InitializedApp(),
      loading: () => const LoadingScreen(),
      error: (error, stack) => MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text(context.l10n.errorText(error)),
          ),
        ),
      ),
    );
  }
}
