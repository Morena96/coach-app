import 'package:coach_app/features/pods/infrastructure/data/hive_pods_data_source.dart';
import 'package:coach_app/features/pods/infrastructure/models/hive_pod.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:domain/features/pods/repositories/pods.dart';
import 'package:coach_app/features/pods/infrastructure/repositories/pods_impl.dart';
import 'package:coach_app/features/pods/infrastructure/data/pods_data_source.dart';

part 'pods_providers.g.dart';

@riverpod
Pods pods(PodsRef ref) {
  final podsDataSource = ref.watch(podsDataSourceProvider);
  return PodsImpl(podsDataSource);
}

@riverpod
PodsDataSource podsDataSource(PodsDataSourceRef ref) {
  var box = Hive.box<HivePod>('pods');
  return HivePodsDataSource(box);
}

