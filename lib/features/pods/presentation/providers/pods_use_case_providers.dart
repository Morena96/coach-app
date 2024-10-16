import 'package:coach_app/features/pods/presentation/providers/pods_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:application/pods/use_cases/get_all_pods_use_case.dart';
import 'package:application/pods/use_cases/get_pod_by_id_use_case.dart';
import 'package:application/pods/use_cases/save_pod_use_case.dart';
import 'package:application/pods/use_cases/update_pod_use_case.dart';

part 'pods_use_case_providers.g.dart';

@riverpod
GetAllPodsUseCase getAllPodsUseCase(GetAllPodsUseCaseRef ref) {
  final pods = ref.watch(podsProvider);
  return GetAllPodsUseCase(pods);
}

@riverpod
GetPodByIdUseCase getPodByIdUseCase(GetPodByIdUseCaseRef ref) {
  final pods = ref.watch(podsProvider);
  return GetPodByIdUseCase(pods);
}

@riverpod
UpdatePodUseCase updatePodUseCase(UpdatePodUseCaseRef ref) {
  final pods = ref.watch(podsProvider);
  return UpdatePodUseCase(pods);
}

@riverpod
SavePodUseCase savePodUseCase(SavePodUseCaseRef ref) {
  final pods = ref.watch(podsProvider);
  return SavePodUseCase(pods);
}
