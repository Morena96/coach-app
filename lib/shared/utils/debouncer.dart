import 'dart:async';

import 'package:flutter/material.dart';

/// A utility class for debouncing operations.
class Debouncer {
  final Duration delay;
  Timer? _timer;

  /// Creates a new [Debouncer] instance with the specified [delay].
  Debouncer({required this.delay});

  /// Runs the provided [action] after the specified delay.
  /// If called again before the delay has passed, the previous call is canceled.
  void run(void Function() action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  /// Cancels any pending debounced actions.
  void cancel() {
    _timer?.cancel();
  }
}

/// A mixin that provides debounce functionality to a [State] object.
mixin DebounceMixin<T extends StatefulWidget> on State<T> {
  Debouncer? _debouncer;

  /// Creates and returns a [Debouncer] with the specified [delay].
  Debouncer getDebouncer({Duration delay = const Duration(milliseconds: 300)}) {
    _debouncer ??= Debouncer(delay: delay);
    return _debouncer!;
  }

  @override
  void dispose() {
    _debouncer?.cancel();
    super.dispose();
  }
}
