import 'package:domain/features/shared/value_objects/sort_criteria.dart';
import 'package:domain/features/shared/value_objects/sort_order.dart';

class AthleteSortCriteria extends SortCriteria {
  AthleteSortCriteria({super.field, super.order});

  AthleteSortCriteria copyWith({String? field, SortOrder? order}) {
    return AthleteSortCriteria(
      field: field ?? this.field,
      order: order ?? this.order,
    );
  }
}
