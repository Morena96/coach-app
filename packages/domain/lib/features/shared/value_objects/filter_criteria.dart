import 'package:equatable/equatable.dart';

abstract class FilterCriteria extends Equatable {
  Map<String, dynamic> toMap();
}
