import 'package:domain/features/athletes/data/id_generator.dart';
import 'package:uuid/uuid.dart';

class UuidIdGenerator implements IdGenerator {
  UuidIdGenerator();

  @override
  String generate() {
    return const Uuid().v6();
  }
}
