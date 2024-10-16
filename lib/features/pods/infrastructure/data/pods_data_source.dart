import 'package:domain/features/pods/entities/pod.dart';

abstract class PodsDataSource {
  Future<List<Pod>> getAllPods();
  Future<Pod?> getPodById(String id);
  Future<void> savePod(Pod podMap);
  Future<void> deletePod(String id);
}

class PodDataSourceException implements Exception {
  final String message;

  PodDataSourceException(this.message);

  @override
  String toString() => 'PodDataSourceException: $message';
}