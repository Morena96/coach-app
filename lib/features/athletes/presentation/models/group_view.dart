import 'package:domain/features/athletes/entities/group.dart';
import 'package:equatable/equatable.dart';

import 'package:coach_app/features/athletes/presentation/models/sport_view.dart';

/// Represents a view model for a group in the application.
class GroupView extends Equatable {
  final String id;
  final String name;
  final String? description;
  final String? avatarId;
  final SportView? sport;
  final bool archived;

  const GroupView({
    required this.id,
    required this.name,
    this.description,
    this.avatarId,
    this.sport,
    this.archived = false,
  });

  factory GroupView.fromDomain(Group group) {
    return GroupView(
      id: group.id,
      name: group.name,
      description: group.description,
      sport: group.sport != null ? SportView.fromDomain(group.sport!) : null,
      avatarId: group.avatarId,
      archived: group.archived,
    );
  }

  factory GroupView.empty() => const GroupView(
      id: '', name: '', description: '', sport: null, archived: false);

  @override
  List<Object?> get props => [id, name, avatarId, description];
}

extension GroupViewX on GroupView {
  /// Converts a GroupView to a Group domain entity
  Group toDomain() {
    return Group(
      id: id,
      name: name,
      description: description,
      avatarId: avatarId,
      sport: sport?.toDomain(),
      archived: archived,
    );
  }
}
