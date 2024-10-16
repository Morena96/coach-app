import 'package:domain/features/logging/repositories/logger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:coach_app/features/antenna_system/infrastructure/factories/desktop_serial_port_adapter_factory.dart';
import 'package:coach_app/features/antenna_system/infrastructure/factories/get_serial_port_adapter_factory_desktop.dart';

class MockLoggerRepository extends Mock implements LoggerRepository {}

void main() {
  group('getSerialPortAdapterFactory', () {
    late MockLoggerRepository mockLogger;

    setUp(() {
      mockLogger = MockLoggerRepository();
    });

    test('returns NoopSerialPortAdapterFactory when not on desktop or web', () {
      // Simulate a mobile environment
      final factory = getSerialPortAdapterFactory(mockLogger);
      expect(factory, isA<DesktopSerialPortAdapterFactory>());
    });
  });
}
