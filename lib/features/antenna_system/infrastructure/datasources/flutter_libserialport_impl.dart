import 'dart:async';
import 'dart:typed_data';

import 'package:application/antenna_system/hex_converter.dart';
import 'package:domain/features/antenna_system/entities/antenna_info.dart';
import 'package:domain/features/antenna_system/services/serial_port_service.dart';
import 'package:coach_app/features/antenna_system/infrastructure/factories/serial_port_factory.dart';
import 'package:domain/features/logging/repositories/logger.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:meta/meta.dart';

///
/// Adapter for the Flutter Libserialport package
/// Provides implementation for the SerialPortService, SerialPortCommandService
/// and SerialPortDataService interfaces
///
class FlutterLibserialportImpl
    implements
        SerialPortService,
        SerialPortCommandService,
        SerialPortDataService {
  static const int antennaVendorId = 0x1915;
  static const int antennaProductId = 0x520f;

  final Map<String, SerialPort> _ports = {};
  final Map<String, SerialPortReader> _readers = {};
  final StreamController<List<AntennaInfo>> _antennaStreamController =
      StreamController<List<AntennaInfo>>.broadcast();
  final SerialPortFactory serialPortFactory;
  final HexConverter hexConverter;
  Timer? _portMonitorTimer;

  LoggerRepository logger;

  FlutterLibserialportImpl(this.logger, this.serialPortFactory, this.hexConverter) {
    _startPortMonitoring();
  }

  void _startPortMonitoring() {
    _portMonitorTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => _updatePorts());
  }

  void _updatePorts() {
    final availablePorts = serialPortFactory.getAvailablePorts();

    // Remove ports that are no longer available
    _ports.keys
        .where((port) => !availablePorts.contains(port))
        .toList()
        .forEach(_removePort);

    // Add new ports
    for (final portName in availablePorts) {
      if (!_ports.containsKey(portName)) {
        _addPort(portName);
      } else {}
    }

    // Update antenna stream
    _antennaStreamController.add(getAvailableAntenna());
  }

  void _addPort(String portName) {
    try {
      final port = serialPortFactory.createSerialPort(portName);
      if (port.vendorId != antennaVendorId ||
          port.productId != antennaProductId) {
        return;
      }
      if (port.open(mode: SerialPortMode.readWrite)) {
        _ports[portName] = port;
        _readers[portName] = serialPortFactory.createSerialPortReader(port);
        logger.info('Opened port: $portName');
      } else {
        logger.error('Failed to open port: $portName');
      }
    } catch (e) {
      logger.error('Failed to open port: $portName', e);
    }
  }

  void _removePort(String portName) {
    _readers[portName]?.close();
    _readers.remove(portName);
    _ports[portName]?.close();
    _ports.remove(portName);
  }

  @override
  List<AntennaInfo> getAvailableAntenna() {
    return _ports.entries
        .map((entry) => _getAntennaInfo(entry.key, entry.value))
        .toList();
  }

  @override
  List<String> getAvailablePorts() {
    return _ports.keys.toList();
  }

  @override
  AntennaInfo getAntennaInfo(String portName) {
    final port = _ports[portName];
    if (port == null) {
      logger.error('Port not found: $portName');
      throw Exception('Port not found: $portName');
    }
    return _getAntennaInfo(portName, port);
  }

  AntennaInfo _getAntennaInfo(String portName, SerialPort port) {
    return AntennaInfo(
      portName: portName,
      description: port.description ?? '-',
      serialNumber: port.serialNumber ?? '-',
      vendorId: port.vendorId ?? 0,
      productId: port.productId ?? 0,
    );
  }

  @override
  Stream<List<AntennaInfo>> getAntennaStream() {
    return _antennaStreamController.stream;
  }

  @override
  Future<void> sendCommand(String portName, Uint8List command) async {
    final port = _ports[portName];
    if (port == null) {
      logger.error('Port not found: $portName');
      throw Exception('Port not found: $portName');
    }
    try {
      port.write(command);
      logger.debug('Sent command to port: $portName');
    } catch (e) {
      logger.error('Failed to send command to port: $portName', e);
      _removePort(portName);
      _addPort(portName);
      rethrow;
    }
  }

  @override
  Future<void> sendCommandToAll(Uint8List command) async {
    logger.debug(
        'Sending command to all ports ${hexConverter.bytesToHex(command)}');
    for (final portName in _ports.keys) {
      await sendCommand(portName, command);
    }
  }

  @override
  Future<void> closeAll() async {
    for (final portName in _ports.keys.toList()) {
      _removePort(portName);
    }
  }

  @override
  Future<void> closePort(String portName) async {
    _removePort(portName);
  }

  @override
  Stream<Uint8List> getDataStream(String portName) {
    final reader = _readers[portName];
    if (reader == null) {
      logger.error('Port not found or not open: $portName');
      throw Exception('Port not found or not open: $portName');
    }
    return reader.stream;
  }

  // Expose a method to manually trigger port update (for testing)
  @visibleForTesting
  void updatePortsForTesting() {
    _updatePorts();
  }

  void dispose() {
    _portMonitorTimer?.cancel();
    closeAll();
    _antennaStreamController.close();
  }
}