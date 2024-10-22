import 'package:coach_app/features/sessions/presentation/providers/update_session_use_case_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:coach_app/features/sessions/presentation/providers/delete_session_use_case_provider.dart';
import 'package:coach_app/features/sessions/presentation/providers/get_all_sessions_by_page_use_case_provider.dart';
import 'package:coach_app/features/sessions/presentation/providers/sessions_view_model.dart';

final sessionsViewModelProvider = StateNotifierProvider.autoDispose
    .family<SessionsViewModel, AsyncValue<void>, String?>(
        (ref, initialGroupId) {
  ref.keepAlive();

  final getAllSessionsByPageUseCase =
      ref.watch(getAllSessionsByPageUseCaseProvider);
  final deleteSessionUseCase = ref.watch(deleteSessionUseCaseProvider);
  final updateSessionUseCase = ref.watch(updateSessionUseCaseProvider);

  return SessionsViewModel(
    getAllSessionsByPageUseCase,
    deleteSessionUseCase,
    updateSessionUseCase,
    initialGroupId: initialGroupId,
  );
});
