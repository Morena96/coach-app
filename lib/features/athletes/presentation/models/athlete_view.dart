import 'package:domain/features/athletes/entities/athlete.dart';
import 'package:equatable/equatable.dart';

import 'package:coach_app/features/athletes/presentation/models/sport_view.dart';

class AthleteView extends Equatable {
  final String id;
  final String name;
  final String avatarPath;
  final List<SportView>? sports;
  final bool archived;
  final List<String> groups;

  const AthleteView({
    required this.id,
    required this.name,
    required this.avatarPath,
    required this.sports,
    this.archived = false,
    required this.groups,
  });

  factory AthleteView.fromDomain(Athlete athlete) {
    return AthleteView(
      id: athlete.id,
      name: athlete.name,
      avatarPath: athlete.avatarId ?? '',
      sports: athlete.sports?.map(SportView.fromDomain).toList(),
      archived: athlete.archived,
      groups: athlete.groups,
    );
  }
  factory AthleteView.empty() => const AthleteView(
      id: '', name: '', avatarPath: '', sports: [], groups: []);

  @override
  List<Object?> get props => [id];
}

extension AthleteViewX on AthleteView {
  /// Converts an AthleteView to an Athlete domain entity
  Athlete toDomain() {
    return Athlete(
      id: id,
      name: name,
      avatarId: avatarPath.isNotEmpty ? avatarPath : null,
      sports: sports?.map((sportView) => sportView.toDomain()).toList(),
      archived: archived,
      groups: groups,
    );
  }
}
