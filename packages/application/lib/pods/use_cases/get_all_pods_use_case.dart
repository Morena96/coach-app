import 'package:domain/features/pods/entities/pod.dart';
import 'package:domain/features/pods/repositories/pods.dart';

class GetAllPodsUseCase {
  final Pods _podsRepository;

  GetAllPodsUseCase(this._podsRepository);

  Future<List<Pod>> execute() {
    return _podsRepository.getAllPods();
  }
}
