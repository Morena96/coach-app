import 'package:coach_app/features/athletes/infrastructure/data/models/hive_member.dart';
import 'package:domain/features/athletes/entities/group.dart';
import 'package:hive/hive.dart';

part 'hive_group.g.dart';

@HiveType(typeId: 2)
class HiveGroup extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late List<HiveMember> members;

  HiveGroup({
    required this.id,
    required this.name,
    required this.members,
  });

  factory HiveGroup.fromDomain(Group group) {
    return HiveGroup(
      id: group.id,
      name: group.name,
      members: group.members.map((member) => HiveMember.fromDomain(member)).toList(),
    );
  }

  Group toDomain() {
    return Group(
      id: id,
      name: name,
      members: members.map((hiveMember) => hiveMember.toDomain()).toList(),
    );
  }
}
