import 'package:domain/features/athletes/data/id_generator.dart';

import 'package:coach_app/features/athletes/infrastructure/data/uuid_id_generator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'id_generator_provider.g.dart';

@Riverpod(keepAlive: true)
IdGenerator idGenerator(IdGeneratorRef ref) {
  return UuidIdGenerator();
}
