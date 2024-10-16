import 'package:equatable/equatable.dart';

class Sport extends Equatable {
  final String id;
  final String name;

  const Sport({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];

  @override
  String toString() => 'Sport(id: $id, name: $name)';

  Sport copyWith({
    String? id,
    String? name,
  }) {
    return Sport(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  factory Sport.fromJson(Map<String, dynamic> json) {
    return Sport(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory Sport.empty() {
    return const Sport(
      id: '',
      name: '',
    );
  }
}
