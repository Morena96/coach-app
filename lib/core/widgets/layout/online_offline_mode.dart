import 'dart:async';

import 'package:coach_app/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import 'package:coach_app/core/app_state.dart';
import 'package:coach_app/core/theme/app_text_style.dart';
import 'package:coach_app/core/widgets/app_dialog.dart';
import 'package:coach_app/core/widgets/arrow_tooltip.dart';
import 'package:coach_app/shared/extensions/context.dart';

class OnlineOfflineMode extends ConsumerWidget {
  OnlineOfflineMode({super.key});

  Function? _hideTooltip;
  Completer<void>? _dialogCompleter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appStateProvider);

    ref.listen<AppState>(appStateProvider, (previous, next) {
      if (previous?.isConnected != next.isConnected) {
        _hideTooltip?.call();

        _handleDialog(context, isConnected: next.isConnected);
      }
    });

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(appState.isConnected
            ? 'assets/icons/online.svg'
            : 'assets/icons/offline.svg'),
        if (!context.isMobile) ...[
          const SizedBox(width: 12),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              appState.isConnected
                  ? context.l10n.onlineMode
                  : context.l10n.offlineMode,
              style: AppTextStyle.primary14b,
            ),
          ),
          const SizedBox(width: 5),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: ArrowTooltip(
              tooltipText: appState.isConnected
                  ? context.l10n.yourDataIsUpToDate
                  : context.l10n.monitorAthletesSessionsOffline,
              onInit: (_, hide) => _hideTooltip = hide,
              child: SvgPicture.asset(
                'assets/icons/question_circle.svg',
                width: 15,
                colorFilter: ColorFilter.mode(
                  context.color.onSurface,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  void _handleDialog(BuildContext context, {required bool isConnected}) async {
    if (_dialogCompleter != null && !_dialogCompleter!.isCompleted) {
      Navigator.of(context).pop();
      await _dialogCompleter!.future;
    }

    _dialogCompleter = Completer<void>();
    // ignore: use_build_context_synchronously
    _showDialog(context, isConnected: isConnected).then((_) {
      _dialogCompleter?.complete();
    });
  }

  Future<void> _showDialog(BuildContext context, {required bool isConnected}) {
    return showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => AppDialog(
        forceDialog: true,
        title: isConnected
            ? context.l10n.onlineModeActivated
            : context.l10n.offlineModeActivated,
        content: Text(
          isConnected
              ? context.l10n.onlineModeActivatedContent
              : context.l10n.offlineModeActivatedContent,
          style: AppTextStyle.secondary16r,
          textAlign: TextAlign.center,
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              context.l10n.gotItContinue,
              style: AppTextStyle.primary14b,
            ),
          ),
        ],
      ),
    );
  }
}
