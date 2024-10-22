import 'package:domain/features/athletes/entities/member.dart';
import 'package:equatable/equatable.dart';

import 'package:coach_app/features/athletes/presentation/models/group_role_view.dart';

class MemberView extends Equatable {
  final String id;
  final String athleteId;
  final String groupId;
  final GroupRoleView role;

  const MemberView({
    required this.id,
    required this.athleteId,
    required this.groupId,
    required this.role,
  });

  factory MemberView.fromDomain(Member member) {
    return MemberView(
      id: member.id,
      athleteId: member.athleteId,
      groupId: member.groupId,
      role: groupRoleViewFromDomain(member.role),
    );
  }

  @override
  List<Object> get props => [id, athleteId, groupId, role];
}

/// Extension on MemberView to provide conversion to domain entity
extension MemberViewX on MemberView {
  /// Converts a MemberView to a Member domain entity
  Member toDomain() {
    return Member(
      id: id,
      athleteId: athleteId,
      groupId: groupId,
      role: groupRoleFromView(role),
    );
  }
}
