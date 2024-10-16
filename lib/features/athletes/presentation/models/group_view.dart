import 'package:domain/features/athletes/entities/group.dart';
import 'package:equatable/equatable.dart';

import 'package:coach_app/features/athletes/presentation/models/member_view.dart';
import 'package:coach_app/features/athletes/presentation/models/sport_view.dart';

/// Represents a view model for a group in the application.
class GroupView extends Equatable {
  final String id;
  final String name;
  final String? description;
  final List<MemberView> members;
  final String? avatarId;
  final SportView? sport;
  final bool archived;

  const GroupView({
    required this.id,
    required this.name,
    this.description,
    required this.members,
    this.avatarId,
    this.sport,
    this.archived = false,
  });

  factory GroupView.fromDomain(Group group) {
    return GroupView(
      id: group.id,
      name: group.name,
      description: group.description,
      members: group.members.map(MemberView.fromDomain).toList(),
      sport: group.sport != null ? SportView.fromDomain(group.sport!) : null,
      avatarId: group.avatarId,
      archived: group.archived,
    );
  }

  @override
  List<Object?> get props => [id, name, members, avatarId, description];
}
