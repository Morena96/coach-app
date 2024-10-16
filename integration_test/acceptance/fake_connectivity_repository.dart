import 'dart:async';

import 'package:coach_app/shared/repositories/connectivity_repository.dart';

class FakeConnectivityRepository implements ConnectivityRepository {
  final StreamController<bool> _controller = StreamController<bool>();

  @override
  Stream<bool> get connectivityStream => _controller.stream;

  @override
  Future<void> initialize() async {
    // Simulate initialization if needed
  }

  @override
  void dispose() {
    _controller.close();
  }

  // Function to manually set the connectivity status
  void setConnectivityStatus(bool isConnected) {
    _controller.add(isConnected);
  }
}
