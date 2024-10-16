// Conditionally import platform-specific implementations
import 'package:coach_app/features/antenna_system/infrastructure/factories/get_serial_port_adapter_factory_ios.dart'
    if (dart.library.io) 'package:coach_app/features/antenna_system/infrastructure/factories/get_serial_port_adapter_factory_desktop.dart'
    if (dart.library.html) 'package:coach_app/features/antenna_system/infrastructure/factories/get_serial_port_adapter_factory_web.dart';

import 'package:coach_app/features/antenna_system/infrastructure/factories/serial_port_adapter_factory.dart';
import 'package:coach_app/shared/providers/logger_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'serial_port_adapter_factory_provider.g.dart';

@Riverpod(keepAlive: true)
SerialPortAdapterFactory serialPortAdapterFactory(
    SerialPortAdapterFactoryRef ref) {
  var logger = ref.watch(loggerProvider);
  return getSerialPortAdapterFactory(logger);
}
