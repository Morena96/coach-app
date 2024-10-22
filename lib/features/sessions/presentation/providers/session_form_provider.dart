import 'package:domain/features/shared/utilities/result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:coach_app/features/athletes/presentation/models/sport_view.dart';
import 'package:coach_app/features/sessions/presentation/models/session_view.dart';
import 'package:coach_app/features/sessions/presentation/providers/sessions_view_model_provider.dart';

part 'session_form_provider.g.dart';

/// Manages the state and logic for the session form
@riverpod
class SessionForm extends _$SessionForm {
  SessionView? _session;

  /// Initializes the form state, optionally with an existing session
  @override
  SessionFormState build({SessionView? initialSession}) {
    if (initialSession != null) {
      _session = initialSession;
      return SessionFormState(
        title: initialSession.title,
        date: initialSession.startTime,
        sport: initialSession.sport,
      );
    }
    return SessionFormState();
  }

  /// Updates the form state with a given session
  void setSession(SessionView session) {
    state = state.copyWith(
        title: session.title, date: session.startTime, sport: session.sport);
  }

  /// Updates the title in the form state
  void setTitle(String title) {
    state = state.copyWith(title: title);
  }

  /// Updates the date in the form state
  void setDate(DateTime date) {
    state = state.copyWith(date: date);
  }

  /// Updates the sport in the form state
  void setSport(SportView sport) {
    state = state.copyWith(sport: sport);
  }

  /// Updates the session with the current form state
  Future<Result<void>> update(SessionView session) async {
    final sessionsViewModel =
        ref.read(sessionsViewModelProvider(null).notifier);
    final sessionData = {
      'title': state.title,
      'date': state.date,
      'sport': state.sport,
    };

    final result = await sessionsViewModel.updateSession(
      (_session ?? SessionView.empty()).copyWith(
        title: state.title,
        startTime: state.date,
        sport: state.sport,
      ),
      sessionData,
    );

    return result;
  }
}

/// Represents the state of the session form
class SessionFormState {
  final String? title;
  final DateTime? date;
  final SportView? sport;

  SessionFormState({
    this.title,
    this.date,
    this.sport,
  });

  /// Checks if the form state is valid
  bool isValid() => (title ?? '').isNotEmpty && date != null && sport != null;

  /// Creates a new instance of SessionFormState with optional updates
  SessionFormState copyWith({
    String? title,
    DateTime? date,
    SportView? sport,
  }) {
    return SessionFormState(
      title: title ?? this.title,
      date: date ?? this.date,
      sport: sport ?? this.sport,
    );
  }
}
