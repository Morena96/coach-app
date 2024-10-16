import 'package:coach_app/core/app_state.dart';
import 'package:coach_app/features/antenna_system/presentation/providers/logs_initializer.dart';
import 'package:coach_app/features/athletes/presentation/providers/athletes_service_provider.dart';
import 'package:coach_app/shared/providers/riverpod_singletons.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final initializationProvider = FutureProvider<void>((ref) async {
  final connectivityRepository = ref.read(connectivityRepositoryProvider);
  final athletesService = ref.read(athletesServiceProvider);
  ref.read(logsInitializerProvider);

  connectivityRepository.connectivityStream.listen((isConnected) {
    ref.read(appStateProvider.notifier).setConnectivityStatus(isConnected);
  });

  await connectivityRepository.initialize();
  await athletesService.initializeDatabase();
  
});
