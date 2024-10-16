import 'dart:async';
import 'dart:typed_data';

import 'package:domain/features/antenna_system/entities/antenna_info.dart';
import 'package:domain/features/antenna_system/repositories/antenna_data_repository.dart';
import 'package:domain/features/antenna_system/services/serial_port_service.dart';
import 'package:domain/features/logging/repositories/logger.dart';
import 'package:coach_app/shared/utils/hex_converter.dart';

class AntennaDataRepositoryImpl implements AntennaDataRepository {
  final SerialPortDataService _serialPortDataService;
  final SerialPortService _serialPortService;
  final LoggerRepository _loggerRepository;

  AntennaDataRepositoryImpl(this._serialPortDataService,
      this._serialPortService, this._loggerRepository) {
    _initializeAntennaMonitoring();
  }

  final Map<String, StreamController<Uint8List>> _dataControllers = {};
  final StreamController<(String, Uint8List)> _aggregatedDataController =
      StreamController<(String, Uint8List)>.broadcast();

  late StreamSubscription<List<AntennaInfo>> _antennaSubscription;

  void _initializeAntennaMonitoring() {
    _antennaSubscription =
        _serialPortService.getAntennaStream().listen(_handleAntennaListUpdate);
  }

  void _handleAntennaListUpdate(List<AntennaInfo> antennas) {
    final currentPorts = antennas.map((a) => a.portName).toSet();
    final knownPorts = _dataControllers.keys.toSet();

    // Remove streams for disconnected antennas
    for (final portName in knownPorts.difference(currentPorts)) {
      _loggerRepository.debug('Repository Removing Data Stream: $portName');
      _removeAntennaStream(portName);
    }

    // Add streams for new antennas
    for (final portName in currentPorts.difference(knownPorts)) {
      _loggerRepository.debug('Repository Adding Data Stream: $portName');
      _addAntennaStream(portName);
    }
  }

  void _addAntennaStream(String portName) {
    _dataControllers[portName] = StreamController<Uint8List>.broadcast();
    _loggerRepository.debug('Repository Adding Data Stream: $portName');
    _serialPortDataService.getDataStream(portName).listen(
      (data) {
        _loggerRepository.debug('Repository Data Received: $portName - ${HexConverter.bytesToHex(data)}');
        _dataControllers[portName]!.add(data);
        _aggregatedDataController.add((portName, data));
      },
      onError: (error) {
        _removeAntennaStream(portName);
      },
      onDone: () {
        _removeAntennaStream(portName);
      },
    );
  }

  void _removeAntennaStream(String portName) async {
    _loggerRepository.debug('Repository Removing Data Stream: $portName');
    if (_dataControllers.containsKey(portName)) {
      final controller = _dataControllers[portName];

      if (controller != null) {
        await controller.close();
        _dataControllers.remove(portName);
      }
    }
  }

  @override
  Stream<Uint8List> getDataStream(String portName) {
    _loggerRepository.debug('Repository Getting Data Stream: $portName');
    if (!_dataControllers.containsKey(portName)) {
      _loggerRepository.error('Port not found or not open: $portName');
      _addAntennaStream(portName);
      return _dataControllers[portName]!.stream;
    }
    return _dataControllers[portName]!.stream;
  }

  @override
  Stream<(String, Uint8List)> getAllDataStreams() {
    return _aggregatedDataController.stream;
  }

  Future<void> dispose() async {
    await _antennaSubscription.cancel();
    for (var controller in _dataControllers.values) {
      await controller.close();
    }
    _dataControllers.clear();
    await _aggregatedDataController.close();
  }
}

class AntennaDataException implements Exception {
  final String message;

  AntennaDataException(this.message);

  @override
  String toString() => 'AntennaDataException: $message';
}
