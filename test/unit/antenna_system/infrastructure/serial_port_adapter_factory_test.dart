import 'package:coach_app/features/antenna_system/infrastructure/adapters/hex_converter_impl.dart';
import 'package:coach_app/features/antenna_system/infrastructure/datasources/flutter_libserialport_impl.dart';
import 'package:coach_app/features/antenna_system/infrastructure/datasources/mock_serialport_impl.dart';
import 'package:coach_app/features/antenna_system/infrastructure/factories/desktop_serial_port_adapter_factory.dart';
import 'package:coach_app/features/antenna_system/infrastructure/factories/noop_serial_port_adapter_factory.dart';
import 'package:coach_app/features/antenna_system/infrastructure/factories/web_serial_port_adapter_factory.dart';
import 'package:domain/features/logging/repositories/logger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Mock LoggerRepository
class MockLoggerRepository extends Mock implements LoggerRepository {}

void main() {
  group('WebSerialPortAdapterFactory', () {
    late WebSerialPortAdapterFactory factory;

    setUp(() {
      factory = WebSerialPortAdapterFactory();
    });

    test('create() returns MockSerialPortAdapter', () {
      expect(factory.create(), isA<MockSerialPortImpl>());
    });

    test('createCommandService() returns MockSerialPortAdapter', () {
      expect(factory.createCommandService(), isA<MockSerialPortImpl>());
    });

    test('createDataService() returns MockSerialPortAdapter', () {
      expect(factory.createDataService(), isA<MockSerialPortImpl>());
    });
  });

  group('DesktopSerialPortAdapterFactory', () {
    late DesktopSerialPortAdapterFactory factory;
    late MockLoggerRepository mockLoggerRepository;

    setUp(() {
      mockLoggerRepository = MockLoggerRepository();
      final hexConverter = HexConverterImpl();
      factory = DesktopSerialPortAdapterFactory(mockLoggerRepository, hexConverter);
    });

    test('create() returns FlutterLibserialportImpl', () {
      expect(factory.create(), isA<FlutterLibserialportImpl>());
    });

    test('createCommandService() returns FlutterLibserialportImpl', () {
      expect(factory.createCommandService(), isA<FlutterLibserialportImpl>());
    });

    test('createDataService() returns FlutterLibserialportImpl', () {
      expect(factory.createDataService(), isA<FlutterLibserialportImpl>());
    });

    test('All methods return the same instance of FlutterLibserialportImpl',
        () {
      final instance1 = factory.create();
      final instance2 = factory.createCommandService();
      final instance3 = factory.createDataService();

      expect(identical(instance1, instance2), isTrue);
      expect(identical(instance1, instance3), isTrue);
    });
  });

  group('NoopSerialPortAdapterFactory', () {
    late NoopSerialPortAdapterFactory factory;

    setUp(() {
      factory = NoopSerialPortAdapterFactory();
    });

    test('create() returns MockSerialPortAdapter', () {
      expect(factory.create(), isA<MockSerialPortImpl>());
    });

    test('createCommandService() returns MockSerialPortAdapter', () {
      expect(factory.createCommandService(), isA<MockSerialPortImpl>());
    });

    test('createDataService() returns MockSerialPortAdapter', () {
      expect(factory.createDataService(), isA<MockSerialPortImpl>());
    });
  });
}
