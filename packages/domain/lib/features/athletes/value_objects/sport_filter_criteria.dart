import 'package:domain/features/shared/value_objects/filter_criteria.dart';

class SportFilterCriteria extends FilterCriteria {
  final String? name;

  SportFilterCriteria({this.name});

  @override
  Map<String, dynamic> toMap() {
    return {'name': name};
  }

  SportFilterCriteria copyWith({
    String? name,
  }) {
    return SportFilterCriteria(
      name: name ?? this.name,
    );
  }

  @override
  List<Object?> get props => [name];
}
