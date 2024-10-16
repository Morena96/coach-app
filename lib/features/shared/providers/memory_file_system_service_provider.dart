import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:coach_app/features/shared/infrastructure/file_system/memory_file_system_service.dart';

part 'memory_file_system_service_provider.g.dart';

/// Provider for the MemoryFileSystemService
@Riverpod(keepAlive: true)
MemoryFileSystemService memoryFileSystemService(MemoryFileSystemServiceRef ref) {
  return MemoryFileSystemService();
}
