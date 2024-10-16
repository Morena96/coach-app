import 'package:coach_app/features/antenna_system/infrastructure/factories/serial_port_adapter_factory.dart';
import 'package:coach_app/features/antenna_system/infrastructure/factories/web_serial_port_adapter_factory.dart';

SerialPortAdapterFactory getSerialPortAdapterFactory(logger) {
  return WebSerialPortAdapterFactory();
}
