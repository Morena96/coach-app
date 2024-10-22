import 'package:domain/features/sessions/entities/session.dart';
import 'package:equatable/equatable.dart';

import 'package:coach_app/features/athletes/presentation/models/athlete_view.dart';
import 'package:coach_app/features/athletes/presentation/models/group_view.dart';
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

  /// The assigned group.
  final GroupView assignedGroup;

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
    required this.assignedGroup,
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
      assignedGroup: GroupView.fromDomain(session.assignedGroup),
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
        assignedGroup: GroupView.empty(),
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
        assignedGroup,
        selectedAthletes,
        gpsDataCount,
      ];

  @override
  String toString() {
    return 'SessionView{id: $id, title: $title, sport: $sport, '
        'startTime: $startTime, duration: $duration, '
        'assignedGroupName: $assignedGroup, '
        'selectedAthletes: $selectedAthletes, '
        'gpsDataCount: $gpsDataCount}';
  }

  /// Creates a copy of this SessionView but with the given fields replaced with the new values.
  SessionView copyWith({
    String? id,
    String? title,
    SportView? sport,
    DateTime? startTime,
    Duration? duration,
    GroupView? assignedGroup,
    List<AthleteView>? selectedAthletes,
    int? gpsDataCount,
  }) {
    return SessionView(
      id: id ?? this.id,
      title: title ?? this.title,
      sport: sport ?? this.sport,
      startTime: startTime ?? this.startTime,
      duration: duration ?? this.duration,
      assignedGroup: assignedGroup ?? this.assignedGroup,
      selectedAthletes: selectedAthletes ?? this.selectedAthletes,
      gpsDataCount: gpsDataCount ?? this.gpsDataCount,
    );
  }
}

extension SessionViewX on SessionView {
  /// Converts a SessionView to a Session domain entity
  Session toDomain() {
    return Session(
      id: id,
      title: title,
      sport: sport.toDomain(),
      startTime: startTime,
      duration: duration,
      assignedGroup: assignedGroup.toDomain(),
      selectedAthletes: selectedAthletes
          .map((athleteView) => athleteView.toDomain())
          .toList(),
      gpsDataRepresentations: [],
    );
  }
}
