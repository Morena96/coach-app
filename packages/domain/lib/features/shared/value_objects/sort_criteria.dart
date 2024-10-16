
import 'package:domain/features/shared/value_objects/sort_order.dart';

abstract class SortCriteria {
  final String? field;
  final SortOrder? order;

  SortCriteria({this.field, this.order});

  Map<String, dynamic> toMap() {
    return {
      'field': field,
      'order': order?.toString().split('.').last,
    };
  }
}
