import 'package:domain/features/sessions/entities/session.dart';
import 'package:equatable/equatable.dart';

import 'package:coach_app/features/athletes/presentation/models/athlete_view.dart';
import 'package:coach_app/features/athletes/presentation/models/sport_view.dart';

/// Represents a session for display in the UI.
class SessionView extends Equatable {
  /// Unique identifier for the session.
  final String id;

  /// Title of the session.
  final String title;

  /// The sport associated with this session.
  final SportView sport;

  /// The start time of the session.
  final DateTime startTime;

  /// The duration of the session.
  final Duration duration;

  /// The name of the assigned group.
  final String assignedGroupName;

  /// The list of athletes selected for this session.
  final List<AthleteView> selectedAthletes;

  /// The number of GPS data representations stored for this session.
  final int gpsDataCount;

  const SessionView({
    required this.id,
    required this.title,
    required this.sport,
    required this.startTime,
    required this.duration,
    required this.assignedGroupName,
    required this.selectedAthletes,
    required this.gpsDataCount,
  });

  /// Creates a SessionView from a domain Session entity.
  factory SessionView.fromDomain(Session session) {
    return SessionView(
      id: session.id,
      title: session.title,
      sport: SportView.fromDomain(session.sport),
      startTime: session.startTime,
      duration: session.duration,
      assignedGroupName: session.assignedGroup.name,
      selectedAthletes: session.selectedAthletes
          .map((athlete) => AthleteView.fromDomain(athlete))
          .toList(),
      gpsDataCount: session.gpsDataRepresentations.length,
    );
  }

  /// Creates an empty SessionView.
  factory SessionView.empty() => SessionView(
        id: '',
        title: '',
        sport: SportView.empty(),
        startTime: DateTime.now(),
        duration: Duration.zero,
        assignedGroupName: '',
        selectedAthletes: const [],
        gpsDataCount: 0,
      );

  @override
  List<Object?> get props => [
        id,
        title,
        sport,
        startTime,
        duration,
        assignedGroupName,
        selectedAthletes,
        gpsDataCount,
      ];

  @override
  String toString() {
    return 'SessionView{id: $id, title: $title, sport: $sport, '
        'startTime: $startTime, duration: $duration, '
        'assignedGroupName: $assignedGroupName, '
        'selectedAthletes: $selectedAthletes, '
        'gpsDataCount: $gpsDataCount}';
  }
}
