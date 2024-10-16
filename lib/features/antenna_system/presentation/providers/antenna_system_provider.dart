import 'package:application/antenna_system/use_cases/get_antenna_system_state_usecase.dart';
import 'package:domain/features/antenna_system/entities/antenna_info.dart';
import 'package:domain/features/antenna_system/repositories/antenna_command_repository.dart';
import 'package:domain/features/antenna_system/repositories/antenna_data_repository.dart';
import 'package:domain/features/antenna_system/repositories/antenna_system_repository.dart';
import 'package:domain/features/antenna_system/services/serial_port_service.dart';
import 'package:coach_app/features/antenna_system/infrastructure/repositories/antenna_command_repository.dart';
import 'package:coach_app/features/antenna_system/infrastructure/repositories/antenna_data_repository_impl.dart';
import 'package:coach_app/features/antenna_system/infrastructure/repositories/antenna_system_repository_impl.dart';
import 'package:coach_app/features/antenna_system/presentation/providers/serial_port_adapter_factory_provider.dart';
import 'package:coach_app/shared/providers/logger_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'antenna_system_provider.g.dart';

@Riverpod(keepAlive: true)
SerialPortService serialPortService(SerialPortServiceRef ref) {
  final factory = ref.watch(serialPortAdapterFactoryProvider);
  return factory.create();
}

@Riverpod(keepAlive: true)
SerialPortCommandService serialPortCommandService(
    SerialPortCommandServiceRef ref) {
  final factory = ref.watch(serialPortAdapterFactoryProvider);
  return factory.createCommandService();
}

@Riverpod(keepAlive: true)
SerialPortDataService serialPortDataService(SerialPortDataServiceRef ref) {
  final factory = ref.watch(serialPortAdapterFactoryProvider);
  return factory.createDataService();
}

final antennaCommandRepositoryProvider =
    Provider<AntennaCommandRepository>((ref) {
  var service = ref.watch(serialPortCommandServiceProvider);
  var logger = ref.watch(loggerProvider);
  return AntennaCommandRepositoryImpl(service, logger);
});

final antennaDataRepositoryProvider = Provider<AntennaDataRepository>((ref) {
  var service = ref.watch(serialPortDataServiceProvider);
  var otherService = ref.watch(serialPortServiceProvider);
  var logger = ref.watch(loggerProvider);
  return AntennaDataRepositoryImpl(service, otherService, logger);
});

final antennaSystemRepositoryProvider =
    Provider<AntennaSystemRepository>((ref) {
  final service = ref.watch(serialPortServiceProvider);
  return AntennaSystemRepositoryImpl(service);
});

final antennaSystemStateProvider =
    StreamProvider<(AntennaSystemState, List<AntennaInfo>)>((ref) {
  final repository = ref.watch(antennaSystemRepositoryProvider);
  final getAntennaSystemState = GetAntennaSystemStateUseCase(repository);
  return getAntennaSystemState();
});
