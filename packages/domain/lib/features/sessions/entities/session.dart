import 'package:domain/features/athletes/entities/athlete.dart';
import 'package:domain/features/athletes/entities/group.dart';
import 'package:domain/features/athletes/entities/sport.dart';
import 'package:domain/features/sessions/entities/gps_data_representation.dart';

/// Represents a GPS tracking session in the system.
class Session {
  /// Unique identifier for the session.
  final String id;

  /// Title of the session.
  final String title;

  /// The sport associated with this session.
  final Sport sport;

  /// The start time of the session.
  final DateTime startTime;

  /// The duration of the session.
  final Duration duration;

  /// The group associated with this session.
  final Group assignedGroup;

  /// The list of athletes selected for this session.
  final List<Athlete> selectedAthletes;

  /// The GPS data representations stored for this session.
  final List<GpsDataRepresentation> gpsDataRepresentations;

  Session({
    required this.id,
    required this.title,
    required this.sport,
    required this.startTime,
    required this.duration,
    required this.assignedGroup,
    required this.selectedAthletes,
    required this.gpsDataRepresentations,
  });

  /// Creates a copy of this Session but with the given fields replaced with the new values.
  Session copyWith({
    String? id,
    String? title,
    Sport? sport,
    DateTime? startTime,
    Duration? duration,
    Group? assignedGroup,
    List<Athlete>? selectedAthletes,
    List<GpsDataRepresentation>? gpsDataRepresentations,
  }) {
    return Session(
      id: id ?? this.id,
      title: title ?? this.title,
      sport: sport ?? this.sport,
      startTime: startTime ?? this.startTime,
      duration: duration ?? this.duration,
      assignedGroup: assignedGroup ?? this.assignedGroup,
      selectedAthletes: selectedAthletes ?? this.selectedAthletes,
      gpsDataRepresentations:
          gpsDataRepresentations ?? this.gpsDataRepresentations,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Session &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          sport == other.sport &&
          startTime == other.startTime &&
          duration == other.duration &&
          assignedGroup == other.assignedGroup &&
          selectedAthletes == other.selectedAthletes &&
          gpsDataRepresentations == other.gpsDataRepresentations;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      sport.hashCode ^
      startTime.hashCode ^
      duration.hashCode ^
      assignedGroup.hashCode ^
      selectedAthletes.hashCode ^
      gpsDataRepresentations.hashCode;

  @override
  String toString() {
    return 'Session{id: $id, title: $title, sport: $sport, '
        'startTime: $startTime, duration: $duration, '
        'assignedGroup: $assignedGroup, selectedAthletes: $selectedAthletes, '
        'gpsDataRepresentations: $gpsDataRepresentations}';
  }

  /// Creates an empty Session instance with default values.
  /// Useful for testing or creating placeholder objects.
  factory Session.empty({String? id, String? title}) {
    return Session(
      id: id ?? '',
      title: title ?? '',
      sport: Sport.empty(),
      startTime: DateTime.now(),
      duration: Duration.zero,
      assignedGroup: Group.empty(),
      selectedAthletes: [],
      gpsDataRepresentations: [],
    );
  }
}
