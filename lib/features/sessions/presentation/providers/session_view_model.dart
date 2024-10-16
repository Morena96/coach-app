import 'package:application/sessions/use_cases/get_session_by_id_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:coach_app/features/sessions/presentation/models/session_view.dart';

/// ViewModel for managing the state of a session view
class SessionViewModel extends StateNotifier<AsyncValue<SessionView>> {
  /// Use case for retrieving a session by ID
  final GetSessionByIdUseCase _getSessionByIdUseCase;

  /// Creates a SessionViewModel with an initial loading state
  SessionViewModel(this._getSessionByIdUseCase)
      : super(const AsyncValue.loading());

  /// Fetches the session data for the given sessionId
  Future<void> fetchSession(String sessionId) async {
    state = const AsyncValue.loading();
    final result = await _getSessionByIdUseCase.execute(sessionId);
    if (result.isSuccess) {
      state = AsyncValue.data(SessionView.fromDomain(result.value!));
    } else {
      state = AsyncValue.error(
        result.error ?? 'Unknown error',
        StackTrace.current,
      );
    }
  }
}
