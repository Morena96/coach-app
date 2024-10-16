import 'package:domain/features/pods/entities/pod.dart';

abstract class Pods {
  Future<List<Pod>> getAllPods();

  Future<Pod> getPodById(String id);

  Future<void> savePod(Pod pod);

  Future<void> updatePod(Pod pod);

  Future<void> deletePod(String id);

  Future<void> batchUpdateAthleteAssociations(
      Map<String, String?> podIdToAthleteId);
}

class PodRepositoryException implements Exception {
  final String message;

  PodRepositoryException(this.message);

  @override
  String toString() => 'PodRepositoryException: $message';
}

class PodNotFoundException implements Exception {
  final String message;

  PodNotFoundException(this.message);

  @override
  String toString() => 'PodNotFoundException: $message';
}