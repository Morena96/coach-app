import 'package:domain/features/avatars/entities/sync_status.dart';
import 'package:equatable/equatable.dart';

class Avatar extends Equatable {
  final String id;
  final String localPath;
  final DateTime lastUpdated;
  final SyncStatus syncStatus;

  const Avatar({
    required this.id,
    required this.localPath,
    required this.lastUpdated,
    required this.syncStatus,
  });

  factory Avatar.fromJson(Map<String, dynamic> json) {
    return Avatar(
      id: json['id'],
      localPath: json['localPath'],
      lastUpdated: DateTime.parse(json['lastUpdated']),
      syncStatus: SyncStatus.values[json['syncStatus']],
    );
  }

  /// Copy with
  Avatar copyWith({
    String? id,
    String? localPath,
    DateTime? lastUpdated,
    SyncStatus? syncStatus,
  }) {
    return Avatar(
      id: id ?? this.id,
      localPath: localPath ?? this.localPath,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }

  @override
  String toString() {
    return 'Avatar{id: $id, localPath: $localPath, lastUpdated: $lastUpdated, syncStatus: $syncStatus}';
  }

  // equatable
  @override
  List<Object?> get props => [id, localPath, lastUpdated, syncStatus];
}
