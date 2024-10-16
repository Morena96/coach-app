import 'package:domain/features/antenna_system/services/serial_port_service.dart';

abstract class SerialPortAdapterFactory {
  SerialPortService create();

  SerialPortCommandService createCommandService();

  SerialPortDataService createDataService();
}
