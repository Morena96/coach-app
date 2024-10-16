import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:coach_app/features/athletes/infrastructure/data/uuid_id_generator.dart';
import 'package:coach_app/features/athletes/presentation/providers/id_generator_provider.dart';

void main() {
  test('idGeneratorProvider creates UuidIdGenerator', () {
    final container = ProviderContainer();

    final generator = container.read(idGeneratorProvider);

    expect(generator, isA<UuidIdGenerator>());
  });
}
