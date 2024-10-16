import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:coach_app/features/shared/infrastructure/file_system/file_system.dart';
import 'package:coach_app/features/shared/infrastructure/file_system/memory_file_system_service.dart';

part 'file_system_service_provider.g.dart';

@Riverpod(keepAlive: true)
FileSystemService fileSystemService(FileSystemServiceRef ref) {
  return MemoryFileSystemService();
}
