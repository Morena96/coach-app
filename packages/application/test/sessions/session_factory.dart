
import 'package:domain/features/athletes/entities/athlete.dart';
import 'package:domain/features/athletes/entities/group.dart';
import 'package:domain/features/athletes/entities/sport.dart';
import 'package:domain/features/sessions/entities/gps_data_representation.dart';
import 'package:domain/features/sessions/entities/session.dart';

class SessionFactory {
  static Session create({
    String id = 'test-id',
    String title = 'Test Session',
    Sport? sport,
    DateTime? startTime,
    Duration duration = const Duration(hours: 1),
    Group? assignedGroup,
    List<Athlete>? selectedAthletes,
    List<GpsDataRepresentation>? gpsDataRepresentations,
  }) {
    return Session(
      id: id,
      title: title,
      sport: sport ?? const Sport(id: 'sport-id', name: 'Test Sport'),
      startTime: startTime ?? DateTime.now(),
      duration: duration,
      assignedGroup: assignedGroup ?? const Group(id: 'group-id', name: 'Test Group', members: []),
      selectedAthletes: selectedAthletes ?? [const Athlete(id: 'athlete-id', name: 'Test Athlete')],
      gpsDataRepresentations: gpsDataRepresentations ?? [],
    );
  }
}