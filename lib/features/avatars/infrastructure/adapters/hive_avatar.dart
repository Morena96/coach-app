import 'package:domain/features/avatars/entities/sync_status.dart';
import 'package:hive/hive.dart';
import 'package:domain/features/avatars/entities/avatar.dart';

part 'hive_avatar.g.dart';

@HiveType(typeId: 10)
class HiveAvatar extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String localPath;

  @HiveField(2)
  late DateTime lastUpdated;

  @HiveField(3)
  late int syncStatus;

  HiveAvatar({
    required this.id,
    required this.localPath,
    required this.lastUpdated,
    required this.syncStatus,
  });

  // Convert HiveAvatar to domain Avatar
  Avatar toDomain() {
    return Avatar(
      id: id,
      localPath: localPath,
      lastUpdated: lastUpdated,
      syncStatus: SyncStatus.values[syncStatus],
    );
  }

  // Create HiveAvatar from domain Avatar
  factory HiveAvatar.fromDomain(Avatar avatar) {
    return HiveAvatar(
      id: avatar.id,
      localPath: avatar.localPath,
      lastUpdated: avatar.lastUpdated,
      syncStatus: avatar.syncStatus.index,
    );
  }
}
