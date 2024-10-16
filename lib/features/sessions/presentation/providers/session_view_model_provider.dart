import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:coach_app/features/sessions/presentation/models/session_view.dart';
import 'package:coach_app/features/sessions/presentation/providers/get_session_by_id_use_case_provider.dart';
import 'package:coach_app/features/sessions/presentation/providers/session_view_model.dart';

/// StateNotifier provider for SessionViewModel
final sessionViewModelProvider = StateNotifierProvider.autoDispose
    .family<SessionViewModel, AsyncValue<SessionView>, String>(
  (ref, sessionId) {
    /// Watches the getSessionByIdUseCase provider
    final getSessionByIdUseCase = ref.watch(getSessionByIdUseCaseProvider);

    /// Creates and returns a SessionViewModel, immediately fetching the session
    return SessionViewModel(getSessionByIdUseCase)..fetchSession(sessionId);
  },
);
