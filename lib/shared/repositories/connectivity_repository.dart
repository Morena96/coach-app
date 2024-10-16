// Repository interface
import 'package:coach_app/shared/services/connectivity/connectivity_service.dart';

abstract class ConnectivityRepository {
  Stream<bool> get connectivityStream;

  Future<void> initialize();

  void dispose();
}

// Repository implementation
class ConnectivityRepositoryImpl implements ConnectivityRepository {
  final ConnectivityService _service;

  ConnectivityRepositoryImpl(this._service);

  @override
  Stream<bool> get connectivityStream => _service.connectivityStream;

  @override
  Future<void> initialize() => _service.initialize();

  @override
  void dispose() => _service.dispose();
}
