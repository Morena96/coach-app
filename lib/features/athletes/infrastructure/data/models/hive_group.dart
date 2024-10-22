import 'package:domain/features/athletes/entities/group.dart';
import 'package:hive/hive.dart';

part 'hive_group.g.dart';

@HiveType(typeId: 2)
class HiveGroup extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String name;

  HiveGroup({
    required this.id,
    required this.name,
  });

  factory HiveGroup.fromDomain(Group group) {
    return HiveGroup(
      id: group.id,
      name: group.name,
    );
  }

  Group toDomain() {
    return Group(
      id: id,
      name: name,
    );
  }
}
