import 'package:domain/features/athletes/entities/sport.dart';
import 'package:hive/hive.dart';

part 'hive_sport.g.dart';

@HiveType(typeId: 4)
class HiveSport extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String name;

  HiveSport({
    required this.id,
    required this.name,
  });

  // Convert HiveSport to domain Sport
  Sport toDomain() {
    return Sport(
      id: id,
      name: name,
    );
  }

  // Create HiveSport from domain Sport
  factory HiveSport.fromDomain(Sport sport) {
    return HiveSport(
      id: sport.id,
      name: sport.name,
    );
  }
}
