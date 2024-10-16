import 'package:domain/features/athletes/entities/group_role.dart';
import 'package:equatable/equatable.dart';

class Member extends Equatable {
  final String id;
  final String athleteId;
  final String groupId;
  final GroupRole role;

  const Member({
    required this.id,
    required this.athleteId,
    required this.groupId,
    required this.role,
  });

  @override
  List<Object> get props => [id, athleteId, groupId, role];

  /// Creates a copy of this Member with the given fields replaced with the new values.
  Member copyWith({
    String? id,
    String? athleteId,
    String? groupId,
    GroupRole? role,
  }) {
    return Member(
      id: id ?? this.id,
      athleteId: athleteId ?? this.athleteId,
      groupId: groupId ?? this.groupId,
      role: role ?? this.role,
    );
  }
}
