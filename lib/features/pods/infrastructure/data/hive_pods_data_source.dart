import 'package:domain/features/pods/entities/pod.dart';
import 'package:coach_app/features/pods/infrastructure/data/pods_data_source.dart';
import 'package:coach_app/features/pods/infrastructure/models/hive_pod.dart';
import 'package:hive/hive.dart';

class HivePodsDataSource extends PodsDataSource {
  final Box<HivePod> _box;

  HivePodsDataSource(this._box);

  @override
  Future<List<Pod>> getAllPods() async {
    try {
      return _box.values.map((hivePod) => hivePod.toDomain()).toList();
    } catch (e) {
      throw PodDataSourceException('Failed to get all pods: ${e.toString()}');
    }
  }

  @override
  Future<Pod?> getPodById(String id) async {
    try {
      final hivePod = _box.get(id);
      return hivePod?.toDomain();
    } on HiveError catch (e) {
      throw PodDataSourceException('Error accessing pod with id $id: ${e.message}');
    } catch (e) {
      throw PodDataSourceException('Unexpected error getting pod with id $id: ${e.toString()}');
    }
  }

  @override
  Future<void> savePod(Pod podMap) async {
    try {
      final hivePod = HivePod.fromDomain(podMap);
      await _box.put(hivePod.id, hivePod);
    } on HiveError catch (e) {
      throw PodDataSourceException('Failed to save pod: ${e.message}');
    } catch (e) {
      throw PodDataSourceException('Unexpected error saving pod: ${e.toString()}');
    }
  }

  @override
  Future<void> deletePod(String id) async {
    try {
      await _box.delete(id);
    } on HiveError catch (e) {
      throw PodDataSourceException('Failed to delete pod with id $id: ${e.message}');
    } catch (e) {
      throw PodDataSourceException('Unexpected error deleting pod with id $id: ${e.toString()}');
    }
  }
}