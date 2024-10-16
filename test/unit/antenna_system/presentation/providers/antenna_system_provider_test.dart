import 'package:domain/features/antenna_system/entities/antenna_info.dart';
import 'package:domain/features/antenna_system/repositories/antenna_command_repository.dart';
import 'package:domain/features/antenna_system/repositories/antenna_data_repository.dart';
import 'package:domain/features/antenna_system/repositories/antenna_system_repository.dart';
import 'package:domain/features/antenna_system/services/serial_port_service.dart';
import 'package:coach_app/features/antenna_system/infrastructure/factories/serial_port_adapter_factory.dart';
import 'package:coach_app/features/antenna_system/presentation/providers/antenna_system_provider.dart';
import 'package:coach_app/features/antenna_system/presentation/providers/serial_port_adapter_factory_provider.dart';
import 'package:domain/features/logging/repositories/logger.dart';
import 'package:coach_app/shared/providers/logger_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:riverpod/riverpod.dart';

@GenerateMocks([
  SerialPortService,
  SerialPortCommandService,
  SerialPortDataService,
  AntennaCommandRepository,
  AntennaDataRepository,
  AntennaSystemRepository,
  LoggerRepository,
  SerialPortAdapterFactory,
])
import 'antenna_system_provider_test.mocks.dart';

void main() {
  late MockSerialPortService mockSerialPortService;
  late MockSerialPortCommandService mockSerialPortCommandService;
  late MockSerialPortDataService mockSerialPortDataService;
  late MockAntennaCommandRepository mockAntennaCommandRepository;
  late MockAntennaDataRepository mockAntennaDataRepository;
  late MockAntennaSystemRepository mockAntennaSystemRepository;
  late MockSerialPortAdapterFactory mockSerialPortAdapterFactory;
  late LoggerRepository mockLogger;
  late ProviderContainer container;

  setUp(() {
    mockSerialPortService = MockSerialPortService();
    mockSerialPortCommandService = MockSerialPortCommandService();
    mockSerialPortDataService = MockSerialPortDataService();
    mockAntennaCommandRepository = MockAntennaCommandRepository();
    mockAntennaDataRepository = MockAntennaDataRepository();
    mockSerialPortAdapterFactory = MockSerialPortAdapterFactory();
    mockAntennaSystemRepository = MockAntennaSystemRepository();
    mockLogger = MockLoggerRepository();

    container = ProviderContainer(
      overrides: [
        serialPortAdapterFactoryProvider.overrideWithValue(mockSerialPortAdapterFactory),
        serialPortServiceProvider.overrideWithValue(mockSerialPortService),
        serialPortCommandServiceProvider
            .overrideWithValue(mockSerialPortCommandService),
        serialPortDataServiceProvider
            .overrideWithValue(mockSerialPortDataService),
        antennaCommandRepositoryProvider
            .overrideWithValue(mockAntennaCommandRepository),
        antennaDataRepositoryProvider
            .overrideWithValue(mockAntennaDataRepository),
        antennaSystemRepositoryProvider
            .overrideWithValue(mockAntennaSystemRepository),

        loggerProvider.overrideWithValue(mockLogger),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('serialPortServiceProvider provides SerialPortService', () {
    final service = container.read(serialPortServiceProvider);
    expect(service, isA<SerialPortService>());
  });

  test('serialPortCommandServiceProvider provides SerialPortCommandService',
      () {
    final service = container.read(serialPortCommandServiceProvider);
    expect(service, isA<SerialPortCommandService>());
  });

  test('serialPortDataServiceProvider provides SerialPortDataService', () {
    final service = container.read(serialPortDataServiceProvider);
    expect(service, isA<SerialPortDataService>());
  });
  test('antennaCommandRepositoryProvider provides AntennaCommandRepository',
      () {
    final repository = container.read(antennaCommandRepositoryProvider);
    expect(repository, isA<AntennaCommandRepository>());
  });

  test('antennaDataRepositoryProvider provides AntennaDataRepository', () {
    final repository = container.read(antennaDataRepositoryProvider);
    expect(repository, isA<AntennaDataRepository>());
  });

  test('antennaSystemRepositoryProvider provides AntennaSystemRepository', () {
    final repository = container.read(antennaSystemRepositoryProvider);
    expect(repository, isA<AntennaSystemRepository>());
  });

  test(
      'antennaSystemStateProvider provides Stream of AntennaSystemState and List<AntennaInfo>',
      () {
    final future = container.read(antennaSystemStateProvider.future);
    expect(future, isA<Future<(AntennaSystemState, List<AntennaInfo>)>>());
  });
}
