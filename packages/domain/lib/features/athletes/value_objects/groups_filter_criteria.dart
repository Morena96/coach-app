import 'package:domain/features/shared/value_objects/filter_criteria.dart';

/// Filter criteria for groups, extending the base FilterCriteria.
class GroupsFilterCriteria extends FilterCriteria {
  /// Filter by group name.
  final String? name;

  /// Filter by sports (list of sport IDs).
  final List<String>? sports;

  /// Filter to include groups with a specific athlete.
  final String? withAthleteId;

  /// Filter to exclude groups with a specific athlete.
  final String? withoutAthleteId;

  /// Constructs a GroupsFilterCriteria with optional filter parameters.
  GroupsFilterCriteria({
    this.name,
    this.sports,
    this.withAthleteId,
    this.withoutAthleteId,
  });

  /// Converts the filter criteria to a map representation.
  @override
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'sports': sports,
      'withAthleteId': withAthleteId,
      'withoutAthleteId': withoutAthleteId,
    };
  }

  /// Creates a copy of this GroupsFilterCriteria with the given fields replaced with the new values.
  GroupsFilterCriteria copyWith({
    String? name,
    List<String>? sports,
    String? withAthleteId,
    String? withoutAthleteId,
  }) {
    return GroupsFilterCriteria(
      name: name ?? this.name,
      sports: sports ?? this.sports,
      withAthleteId: withAthleteId ?? this.withAthleteId,
      withoutAthleteId: withoutAthleteId ?? this.withoutAthleteId,
    );
  }

  /// List of properties used for equality comparison and hashing.
  @override
  List<Object?> get props => [name, sports, withAthleteId, withoutAthleteId];
}
