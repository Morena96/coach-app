import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:coach_app/core/router/app_router.dart';
import 'package:coach_app/core/theme/app_theme.dart';
import 'package:coach_app/features/settings/presentation/providers/settings_view_model.dart';
import 'package:coach_app/l10n.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class InitializedApp extends ConsumerWidget {
  const InitializedApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GoRouter router = ref.watch(goRouterProvider);
    final settingsState = ref.watch(settingsViewModelProvider);

    return settingsState.when(
      data: (_) {

        final themeMode =
            ref.watch(settingsViewModelProvider.notifier).themeMode;
        final locale = ref.watch(settingsViewModelProvider.notifier).locale;

        return MaterialApp.router(
          title: '1Tul Coach App',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.theme(brightness: Brightness.light),
          darkTheme: AppTheme.theme(brightness: Brightness.dark),
          themeMode: themeMode,
          routerConfig: router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: locale,
          builder: (BuildContext context, Widget? child) =>
              child ?? const SizedBox(),
        );
      },
      loading: () => const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (error, _) => MaterialApp(
        home: Scaffold(
          body: Center(child: Text(context.l10n.errorText(error))),
        ),
      ),
    );
  }
}
