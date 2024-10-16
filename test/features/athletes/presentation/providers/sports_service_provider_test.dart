import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/riverpod.dart';
import 'package:coach_app/features/athletes/infrastructure/services/fake_sports_service.dart';
import 'package:coach_app/features/athletes/presentation/providers/sports_service_provider.dart';

void main() {
  test('sportsServiceProvider should return a FakeSportsService', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final sportsService = container.read(sportsServiceProvider);

    expect(sportsService, isA<FakeSportsService>());
  });
}
