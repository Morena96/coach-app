import 'package:domain/features/pods/entities/pod.dart';
import 'package:domain/features/pods/repositories/pods.dart';

class UpdatePodUseCase {
  final Pods _podRepository;

  UpdatePodUseCase(this._podRepository);

  Future<void> execute(Pod pod) async {
    return _podRepository.updatePod(pod);
  }
}
