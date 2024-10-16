import 'package:application/pods/use_cases/save_pod_use_case.dart';
import 'package:application/pods/use_cases/update_pod_use_case.dart';
import 'package:coach_app/features/pods/infrastructure/data/hive_pods_data_source.dart';
import 'package:coach_app/features/pods/infrastructure/repositories/pods_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:domain/features/pods/entities/pod.dart';
import 'package:application/pods/use_cases/get_all_pods_use_case.dart';
import 'package:application/pods/use_cases/get_pod_by_id_use_case.dart';
import 'package:application/pods/use_cases/batch_update_athlete_associations_to_pods_use_case.dart';
import 'package:coach_app/features/pods/infrastructure/models/hive_pod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'dart:io';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late HivePodsDataSource dataSource;
  late PodsImpl repository;
  late GetAllPodsUseCase getAllPodsUseCase;
  late GetPodByIdUseCase getPodByIdUseCase;
  late BatchUpdateAthleteAssociationsToPodsUseCase batchUpdateUseCase;
  late UpdatePodUseCase updatePodUseCase;
  late SavePodUseCase savePodUseCase;
  late Directory testDir;

  setUpAll(() async {
    await Hive.initFlutter();
    Hive.registerAdapter(HivePodAdapter());

    final appSupportDir = await getApplicationSupportDirectory();
    testDir = Directory(path.join(appSupportDir.path, 'integration_test_pods'));

    if (!await testDir.exists()) {
      await testDir.create(recursive: true);
    }

    final box = await Hive.openBox<HivePod>('pods_test', path: testDir.path);
    dataSource = HivePodsDataSource(box);
    repository = PodsImpl(dataSource);
    getAllPodsUseCase = GetAllPodsUseCase(repository);
    getPodByIdUseCase = GetPodByIdUseCase(repository);
    savePodUseCase = SavePodUseCase(repository);
    batchUpdateUseCase =
        BatchUpdateAthleteAssociationsToPodsUseCase(repository);
    updatePodUseCase = UpdatePodUseCase(repository);
  });

  tearDownAll(() async {
    await Hive.deleteFromDisk();
    await testDir.delete(recursive: true);
  });

  testWidgets('Pods integration test', (WidgetTester tester) async {
    // Test saving, updating and getting all pods
    final podsToSave = [
      Pod(id: '1', number: 1, rfSlot: 1),
      Pod(id: '2', number: 2, rfSlot: 2),
      Pod(id: '3', number: 3, rfSlot: 3),
    ];

    for (var pod in podsToSave) {
      await savePodUseCase.execute(pod);
    }

    final allPods = await getAllPodsUseCase.execute();
    expect(allPods.length, equals(3));
    expect(allPods.map((p) => p.id).toSet(), equals({'1', '2', '3'}));

    // Test getting a specific pod by ID
    final retrievedPod = await getPodByIdUseCase.execute('2');
    expect(retrievedPod, isNotNull);
    expect(retrievedPod.id, equals('2'));
    expect(retrievedPod.number, equals(2));
    expect(retrievedPod.rfSlot, equals(2));

    // Test updating a pod
    final updatedPod =
        Pod(id: '2', number: 2, rfSlot: 2, athleteId: 'athlete1');
    await updatePodUseCase.execute(updatedPod);

    final retrievedUpdatedPod = await getPodByIdUseCase.execute('2');
    expect(retrievedUpdatedPod.athleteId, equals('athlete1'));

    // Test batch updating athlete associations
    final podIdToAthleteIdMap = {
      '1': 'athlete2',
      '2': null,
      '3': 'athlete3',
    };
    await batchUpdateUseCase.execute(podIdToAthleteIdMap);

    final updatedPods = await getAllPodsUseCase.execute();
    for (var pod in updatedPods) {
      expect(pod.athleteId, equals(podIdToAthleteIdMap[pod.id]));
    }
  });
}
