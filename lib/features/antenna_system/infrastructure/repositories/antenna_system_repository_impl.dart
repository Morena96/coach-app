import 'dart:async';

import 'package:domain/features/antenna_system/entities/antenna_info.dart';
import 'package:domain/features/antenna_system/repositories/antenna_system_repository.dart';
import 'package:domain/features/antenna_system/services/serial_port_service.dart';

class AntennaSystemRepositoryImpl implements AntennaSystemRepository {
  final SerialPortService _service;
  StreamSubscription<List<AntennaInfo>>? _subscription;
  final _stateController =
      StreamController<(AntennaSystemState, List<AntennaInfo>)>.broadcast();

  AntennaSystemRepositoryImpl(this._service);

  @override
  Stream<(AntennaSystemState, List<AntennaInfo>)> getAntennaSystemStream() {
    _subscription ??= _service.getAntennaStream().listen((antennas) {
      final state = antennas.isNotEmpty
          ? AntennaSystemState.connected
          : AntennaSystemState.disconnected;
      _stateController.add((state, antennas));
    }, onError: (e) {
      _stateController.add((AntennaSystemState.error, <AntennaInfo>[]));
    });
    return _stateController.stream;
  }

  void dispose() {
    _subscription?.cancel();
    _stateController.close();
  }
}
