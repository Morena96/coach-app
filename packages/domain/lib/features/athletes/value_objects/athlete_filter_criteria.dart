import 'package:domain/features/shared/value_objects/filter_criteria.dart';

class AthleteFilterCriteria extends FilterCriteria {
  final String? name;
  final List<String>? sports;
  final bool? isArchived;

  AthleteFilterCriteria({this.name, this.sports, this.isArchived});

  @override
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'sports': sports,
      'isArchived': isArchived,
    };
  }

  AthleteFilterCriteria copyWith({
    String? name,
    List<String>? sports,
    bool? isArchived,
  }) {
    return AthleteFilterCriteria(
      name: name ?? this.name,
      sports: sports ?? this.sports,
      isArchived: isArchived ?? this.isArchived,
    );
  }

  @override
  List<Object?> get props => [name, sports];
}
