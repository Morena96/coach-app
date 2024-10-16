import 'package:domain/features/pods/entities/pod.dart';
import 'package:domain/features/pods/repositories/pods.dart';
import 'package:coach_app/features/pods/infrastructure/data/pods_data_source.dart';

class PodsImpl extends Pods {
  final PodsDataSource _dataSource;

  PodsImpl(this._dataSource);

  @override
  Future<void> batchUpdateAthleteAssociations(
      Map<String, String?> podIdToAthleteId) async {
    try {
      await Future.wait(podIdToAthleteId.entries.map((entry) async {
        final podId = entry.key;
        final athleteId = entry.value;
        final pod = await _dataSource.getPodById(podId);
        if (pod != null) {
          final updatedPod = pod.copyWith(athleteId: athleteId);
          await _dataSource.savePod(updatedPod);
        }
      }));
    } catch (e) {
      throw PodRepositoryException(
          'Failed to batch update athlete associations: ${e.toString()}');
    }
  }

  @override
  Future<void> deletePod(String id) async {
    try {
      await _dataSource.deletePod(id);
    } catch (e) {
      throw PodRepositoryException('Failed to delete pod: ${e.toString()}');
    }
  }

  @override
  Future<List<Pod>> getAllPods() async {
    try {
      return await _dataSource.getAllPods();
    } catch (e) {
      throw PodRepositoryException('Failed to get all pods: ${e.toString()}');
    }
  }

  @override
  Future<Pod> getPodById(String id) async {
    try {
      final pod = await _dataSource.getPodById(id);
      if (pod == null) {
        throw PodNotFoundException('Pod with id $id not found');
      }
      return pod;
    } catch (e) {
      if (e is PodNotFoundException) rethrow;
      throw PodRepositoryException('Failed to get pod: ${e.toString()}');
    }
  }

  @override
  Future<void> savePod(Pod pod) async {
    try {
      await _dataSource.savePod(pod);
    } catch (e) {
      throw PodRepositoryException('Failed to save pod: ${e.toString()}');
    }
  }

  @override
  Future<void> updatePod(Pod pod) async {
    try {
      final existingPod = await _dataSource.getPodById(pod.id);
      if (existingPod == null) {
        throw PodNotFoundException('Pod with id ${pod.id} not found');
      }
      await _dataSource.savePod(pod);
    } catch (e) {
      if (e is PodNotFoundException) rethrow;
      throw PodRepositoryException('Failed to update pod: ${e.toString()}');
    }
  }
}
