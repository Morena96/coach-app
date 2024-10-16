import 'package:domain/features/athletes/entities/athlete.dart';
import 'package:domain/features/athletes/entities/sport.dart';
import 'package:hive/hive.dart';

part 'hive_athlete.g.dart';

@HiveType(typeId: 1)
class HiveAthlete extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late String? avatarId;

  @HiveField(3)
  late List<String>? sportIds;

  @HiveField(4)
  late bool archived;

  HiveAthlete({
    required this.id,
    required this.name,
    this.avatarId,
    this.sportIds,
    this.archived = false,
  });

  // Convert HiveAthlete to domain Athlete
  Athlete toDomain(List<Sport> sports) {
    return Athlete(
      id: id,
      name: name,
      avatarId: avatarId,
      sports: sportIds?.map((id) => sports.firstWhere((sport) => sport.id == id)).toList() ?? [],
      archived: archived,
    );
  }

  factory HiveAthlete.fromDomain(Athlete athlete) {
    return HiveAthlete(
      id: athlete.id,
      name: athlete.name,
      avatarId: athlete.avatarId,
      sportIds: athlete.sports?.map((e) => e.id).toList() ?? [],
      archived: athlete.archived,
    );
  }
}
