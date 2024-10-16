import 'package:application/antenna_system/hex_converter.dart';
import 'package:coach_app/features/antenna_system/infrastructure/adapters/hex_converter_impl.dart';
import 'package:coach_app/features/antenna_system/infrastructure/factories/desktop_serial_port_adapter_factory.dart';
import 'package:coach_app/features/antenna_system/infrastructure/factories/serial_port_adapter_factory.dart';

SerialPortAdapterFactory getSerialPortAdapterFactory(logger) {
  final HexConverter hexConverter = HexConverterImpl();
  return DesktopSerialPortAdapterFactory(logger, hexConverter);
}
