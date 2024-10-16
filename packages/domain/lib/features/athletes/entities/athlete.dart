import 'package:domain/features/athletes/entities/sport.dart';
import 'package:equatable/equatable.dart';

class Athlete extends Equatable {
  final String id;
  final String name;
  final String? avatarId;
  final List<Sport>? sports;
  final bool archived;
  final List<String> groups;

  const Athlete({
    required this.id,
    required this.name,
    this.avatarId,
    this.sports,
    this.archived = false,
    this.groups = const [],
  });

  /// copyWith method
  Athlete copyWith({
    String? id,
    String? name,
    String? avatarId,
    List<Sport>? sports,
    bool? archived,
    List<String>? groups,
  }) {
    return Athlete(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarId: avatarId ?? this.avatarId,
      sports: sports ?? this.sports,
      archived: archived ?? this.archived,
      groups: groups ?? this.groups,
    );
  }

  /// fromMap factory method
  factory Athlete.fromJson(Map<String, dynamic> map) {
    return Athlete(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      avatarId: map['avatarId'],
      sports: map['sports'] ?? [],
      archived: map['archived'] ?? false,
      groups: map['groups'] ?? [],
    );
  }

  factory Athlete.empty() =>
      const Athlete(id: '', name: '', avatarId: '', sports: [], groups: []);

  @override
  String toString() {
    return 'Athlete(id: $id, name: $name, avatarId: $avatarId, '
        'sports: $sports, archived: $archived)';
  }

  @override
  List<Object?> get props => [id, name, avatarId, sports, archived];
}
