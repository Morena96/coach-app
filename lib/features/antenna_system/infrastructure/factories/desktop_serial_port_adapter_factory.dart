import 'package:application/antenna_system/hex_converter.dart';
import 'package:coach_app/features/antenna_system/infrastructure/datasources/flutter_libserialport_impl.dart';
import 'package:coach_app/features/antenna_system/infrastructure/factories/flutter_libserialport_factory.dart';
import 'package:coach_app/features/antenna_system/infrastructure/factories/serial_port_adapter_factory.dart';
import 'package:domain/features/antenna_system/services/serial_port_service.dart';
import 'package:domain/features/logging/repositories/logger.dart';

class DesktopSerialPortAdapterFactory implements SerialPortAdapterFactory {
  final LoggerRepository _loggerRepository;
  final HexConverter _hexConverter;

  // Single instance of FlutterLibserialportImpl
  late final FlutterLibserialportImpl _adapter;

  DesktopSerialPortAdapterFactory(this._loggerRepository, this._hexConverter) {
    _adapter = FlutterLibserialportImpl(
        _loggerRepository, FlutterLibSerialPortFactory(), _hexConverter);
  }

  @override
  SerialPortService create() => _adapter;

  @override
  SerialPortCommandService createCommandService() => _adapter;

  @override
  SerialPortDataService createDataService() => _adapter;
}
