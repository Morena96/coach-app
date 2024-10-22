import 'package:domain/features/athletes/entities/sport.dart';
import 'package:equatable/equatable.dart';

class SportView extends Equatable {
  final String id;
  final String name;

  const SportView({
    required this.id,
    required this.name,
  });

  factory SportView.fromDomain(Sport sport) =>
      SportView(id: sport.id, name: sport.name);

  factory SportView.empty() => const SportView(id: '', name: '');

  @override
  List<Object?> get props => [id, name];
}

extension SportViewX on SportView {
  Sport toDomain() {
    return Sport(
      id: id,
      name: name,
    );
  }
}
