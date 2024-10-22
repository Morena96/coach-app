import 'dart:typed_data';

/// StorageAdapter
///
/// StorageAdapter abstracts the storage mechanism for the processed data. It enables the system
/// to persist processed frames in a flexible manner, supporting various storage backends like
/// local filesystems, cloud storage services, or databases. Implementations of StorageAdapter
/// can vary based on storage requirements and configurations.
///
/// Responsibilities:
/// - Persisting processed frames in the designated storage system.
/// - Providing a unified interface for data storage operations, allowing for easy swapping
///   or addition of new storage mechanisms.
/// - Ensuring data integrity and efficient storage of processed information.
abstract class StorageAdapter {
  Future<void> initialize();

  Future<void> write(Uint8List data);

  Future<void> finalize();

  // Add a method to retrieve the stored file path
  String getFilePath();
}
