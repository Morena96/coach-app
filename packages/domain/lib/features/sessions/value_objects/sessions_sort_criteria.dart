import 'package:domain/features/shared/value_objects/sort_criteria.dart';
import 'package:domain/features/shared/value_objects/sort_order.dart';

class SessionsSortCriteria extends SortCriteria {
  SessionsSortCriteria({super.field, super.order});

  SessionsSortCriteria copyWith({String? field, SortOrder? order}) {
    return SessionsSortCriteria(
      field: field ?? this.field,
      order: order ?? this.order,
    );
  }
}
