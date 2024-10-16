import 'package:domain/features/athletes/entities/member.dart';
import 'package:domain/features/athletes/entities/sport.dart';
import 'package:equatable/equatable.dart';

class Group extends Equatable {
  final String id;
  final String name;
  final String? description;
  final List<Member> members;
  final String? avatarId;
  final Sport? sport;
  final bool archived;

  const Group({
    required this.id,
    required this.name,
    this.description,
    required this.members,
    this.avatarId,
    this.sport,
    this.archived = false,
  });

  Group copyWith({
    String? id,
    String? name,
    String? description,
    List<Member>? members,
    String? avatarId,
    Sport? sport,
    bool? archived,
  }) {
    return Group(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      members: members ?? this.members,
      avatarId: avatarId ?? this.avatarId,
      sport: sport ?? this.sport,
      archived: archived ?? this.archived,
    );
  }

  /// Creates an empty Group instance with default values.
  factory Group.empty() {
    return Group(
      id: '',
      name: '',
      description: null,
      members: [],
      avatarId: null,
      sport: null,
      archived: false,
    );
  }

  @override
  String toString() {
    return avatarId.toString();
  }

  @override
  List<Object?> get props => [id, name, description, members, avatarId, sport];
}
