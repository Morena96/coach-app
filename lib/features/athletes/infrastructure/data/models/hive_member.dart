import 'package:domain/features/athletes/entities/group_role.dart';
import 'package:domain/features/athletes/entities/member.dart';
import 'package:hive/hive.dart';

part 'hive_member.g.dart';

@HiveType(typeId: 3)
class HiveMember extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String athleteId;

  @HiveField(2)
  late String groupId;

  @HiveField(3)
  late String role;

  HiveMember({
    required this.id,
    required this.athleteId,
    required this.groupId,
    required this.role,
  });

  factory HiveMember.fromDomain(Member member) {
    return HiveMember(
      id: member.id,
      athleteId: member.athleteId,
      groupId: member.groupId,
      role: member.role.name,
    );
  }

  Member toDomain() {
    return Member(
      id: id,
      athleteId: athleteId,
      groupId: groupId,
      role: GroupRole.values.byName(role),
    );
  }
}
