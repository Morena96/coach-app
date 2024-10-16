import 'package:coach_app/features/avatars/infrastructure/services/avatar_database_service.dart';
import 'package:coach_app/features/avatars/infrastructure/services/in_memory_avatar_database_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'avatar_database_service_provider.g.dart';

/// Provider for the AvatarDatabaseService
@Riverpod(keepAlive: true)
AvatarDatabaseService avatarDatabaseService(AvatarDatabaseServiceRef ref) {
  return InMemoryAvatarDatabaseService();
}
