import 'package:domain/features/pods/entities/pod.dart';
import 'package:domain/features/pods/repositories/pods.dart';

class GetPodByIdUseCase {
  final Pods _podRepository;

  GetPodByIdUseCase(this._podRepository);

  Future<Pod> execute(String id) {
    return _podRepository.getPodById(id);
  }
}
