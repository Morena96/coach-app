import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity connectivity;
  final StreamController<bool> connectivityController;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  ConnectivityService({
    Connectivity? connectivity,
    StreamController<bool>? connectivityController,
  })  : connectivity = connectivity ?? Connectivity(),
        connectivityController = connectivityController ?? StreamController<bool>.broadcast() {
    _connectivitySubscription = this.connectivity.onConnectivityChanged.listen((result) {
      this.connectivityController.add(isConnected(result));
    });
  }

  bool isConnected(List<ConnectivityResult> results) {
    return results.contains(ConnectivityResult.ethernet) ||
        results.contains(ConnectivityResult.wifi) ||
        results.contains(ConnectivityResult.mobile);
  }

  Stream<bool> get connectivityStream => connectivityController.stream;

  Future<void> initialize() async {
    final initialResult = await connectivity.checkConnectivity();
    connectivityController.add(isConnected(initialResult));
  }

  void dispose() {
    _connectivitySubscription.cancel();
    connectivityController.close();
  }
}