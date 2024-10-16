import 'package:domain/features/pods/repositories/pods.dart';

class BatchUpdateAthleteAssociationsToPodsUseCase {
  final Pods _podRepository;

  BatchUpdateAthleteAssociationsToPodsUseCase(this._podRepository);

  Future<void> execute(Map<String, String?> podIdToAthleteIdMap) async {
    _podRepository.batchUpdateAthleteAssociations(
      podIdToAthleteIdMap,
    );
  }
}
