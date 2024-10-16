import 'package:equatable/equatable.dart';

class Setting extends Equatable {
  final String key;
  final dynamic value;

  const Setting(this.key, this.value);

  @override
  List<Object?> get props => [key, value];
}
