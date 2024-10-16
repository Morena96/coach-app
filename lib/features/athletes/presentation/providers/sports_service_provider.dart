
import 'package:domain/features/athletes/data/sports_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:coach_app/features/athletes/infrastructure/services/fake_sports_service.dart';

part 'sports_service_provider.g.dart';

@Riverpod(keepAlive: true)
SportsService sportsService(SportsServiceRef ref) {
  return FakeSportsService();
}
