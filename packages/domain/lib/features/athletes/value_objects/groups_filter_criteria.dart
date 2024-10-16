import 'package:domain/features/shared/value_objects/filter_criteria.dart';

class GroupsFilterCriteria extends FilterCriteria {
  final String? name;
  final List<String>? sports;

  GroupsFilterCriteria({
    this.name,
    this.sports,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'sports': sports,
    };
  }

  GroupsFilterCriteria copyWith({
    String? name,
    List<String>? sports,
  }) {
    return GroupsFilterCriteria(
      name: name ?? this.name,
      sports: sports ?? this.sports,
    );
  }

  @override
  List<Object?> get props => [name, sports];
}
