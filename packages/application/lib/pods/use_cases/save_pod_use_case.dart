import 'package:domain/features/pods/entities/pod.dart';
import 'package:domain/features/pods/repositories/pods.dart';

class SavePodUseCase {
  final Pods _podRepository;

  SavePodUseCase(this._podRepository);

  Future<void> execute(Pod pod) async {
    await _podRepository.savePod(pod);
  }
}
