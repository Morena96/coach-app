import 'package:coach_app/features/antenna_system/infrastructure/datasources/mock_serialport_impl.dart';
import 'package:coach_app/features/antenna_system/infrastructure/factories/serial_port_adapter_factory.dart';
import 'package:domain/features/antenna_system/services/serial_port_service.dart';

class NoopSerialPortAdapterFactory implements SerialPortAdapterFactory {
  @override
  SerialPortService create() => MockSerialPortImpl();

  @override
  SerialPortCommandService createCommandService() => MockSerialPortImpl();

  @override
  SerialPortDataService createDataService() => MockSerialPortImpl();
}
