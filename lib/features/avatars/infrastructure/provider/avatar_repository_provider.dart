import 'package:coach_app/features/avatars/infrastructure/provider/avatar_database_service_provider.dart';
import 'package:coach_app/features/avatars/infrastructure/provider/image_format_service_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:domain/features/avatars/repositories/avatar_repository.dart';
import 'package:coach_app/features/avatars/infrastructure/repositories/offline_first_avatar_repository.dart';
import 'package:coach_app/shared/providers/dio_provider.dart';
import 'package:coach_app/shared/providers/directory_provider.dart';
import 'package:coach_app/features/shared/providers/file_system_service_provider.dart';

part 'avatar_repository_provider.g.dart';

@Riverpod(keepAlive: true)
AvatarRepository avatarRepository(AvatarRepositoryRef ref) {
  return OfflineFirstAvatarRepository(
    ref.watch(avatarDatabaseServiceProvider),
    ref.watch(directoryProvider),
    ref.watch(dioProvider),
    ref.watch(fileSystemServiceProvider),
    ref.watch(imageFormatServiceProvider),
  );
}
