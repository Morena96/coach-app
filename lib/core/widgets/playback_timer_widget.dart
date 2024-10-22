import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Controller for managing playback timing and speed
class PlaybackTimerController {
  /// Total duration of the playback
  final Duration totalDuration;

  /// List of available playback speeds
  final List<double> availableSpeeds;

  /// Notifier for current playback speed
  final ValueNotifier<double> speedNotifier;

  Ticker? _ticker;
  final _timeController = StreamController<Duration>.broadcast();

  /// Notifier for current playback position
  final ValueNotifier<Duration> currentPosition;

  /// Notifier for playback state (playing/paused)
  final ValueNotifier<bool> isPlaying = ValueNotifier(false);

  Duration _lastTickTime = Duration.zero;
  final Stopwatch _stopwatch = Stopwatch();

  /// Creates a PlaybackTimerController with given total duration and available speeds
  PlaybackTimerController({
    required this.totalDuration,
    this.availableSpeeds = const [1.0, 1.1, 1.2, 1.5, 2.0],
  })  : currentPosition = ValueNotifier(Duration.zero),
        speedNotifier = ValueNotifier(1.0);

  /// Stream of current playback time
  Stream<Duration> get timeStream => Stream.periodic(
        const Duration(milliseconds: 100),
        (_) => currentPosition.value,
      ).takeWhile((_) => isPlaying.value);

  /// Current playback speed
  double get speed => speedNotifier.value;

  /// Set playback speed
  set speed(double newSpeed) {
    if (availableSpeeds.contains(newSpeed) && newSpeed != speedNotifier.value) {
      speedNotifier.value = newSpeed;
      if (isPlaying.value) {
        pause();
        play();
      }
    }
  }

  /// Start playback
  void play() {
    if (!isPlaying.value) {
      isPlaying.value = true;
      _lastTickTime = currentPosition.value;
      _stopwatch.start();
      _ticker = Ticker(_onTick)..start();
    }
  }

  /// Pause playback
  void pause() {
    if (isPlaying.value) {
      isPlaying.value = false;
      _ticker?.stop();
      _ticker?.dispose();
      _ticker = null;
      _stopwatch.stop();
    }
  }

  /// Reset playback to beginning
  void reset() {
    pause();
    _stopwatch.reset();
    seek(Duration.zero);
  }

  /// Seek to a specific position
  void seek(Duration position) {
    if (position <= totalDuration && position >= Duration.zero) {
      currentPosition.value = position;
      _lastTickTime = position;
      _timeController.add(position);
      _stopwatch.reset();
    }
  }

  void _onTick(Duration elapsed) {
    final tickDuration = _stopwatch.elapsed;
    _stopwatch.reset();

    final scaledDuration = tickDuration * speed;
    final newPosition = _lastTickTime + scaledDuration;

    if (newPosition <= totalDuration) {
      currentPosition.value = newPosition;
      _lastTickTime = newPosition;
      _timeController.add(newPosition);
    } else {
      currentPosition.value = totalDuration;
      _lastTickTime = totalDuration;
      _timeController.add(totalDuration);
      pause();
    }
  }

  /// Dispose of resources
  void dispose() {
    _ticker?.dispose();
    _timeController.close();
    currentPosition.dispose();
    isPlaying.dispose();
    speedNotifier.dispose();
  }
}

/// A widget that displays and controls a playback timer
class PlaybackTimerWidget extends StatelessWidget {
  /// Controller for the playback timer
  final PlaybackTimerController controller;

  /// Callback for when seek position changes
  final ValueChanged<Duration>? onSeekChanged;

  /// Creates a PlaybackTimerWidget
  const PlaybackTimerWidget({
    super.key,
    required this.controller,
    this.onSeekChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildPlayPauseButton(),
        const SizedBox(width: 16),
        _buildResetButton(),
        const SizedBox(width: 16),
        _buildTimeDisplay(),
        const SizedBox(width: 16),
        _buildSpeedSelector(),
      ],
    );
  }

  Widget _buildTimeDisplay() {
    return ValueListenableBuilder<Duration>(
      valueListenable: controller.currentPosition,
      builder: (context, currentPosition, child) {
        return Text(
          '${_formatDuration(currentPosition)} / ${_formatDuration(controller.totalDuration)}',
          style: const TextStyle(fontSize: 16),
        );
      },
    );
  }

  Widget _buildPlayPauseButton() {
    return ValueListenableBuilder<bool>(
      valueListenable: controller.isPlaying,
      builder: (context, isPlaying, child) {
        return IconButton(
          icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
          onPressed: isPlaying ? controller.pause : controller.play,
        );
      },
    );
  }

  Widget _buildResetButton() {
    return IconButton(
      icon: const Icon(Icons.replay),
      onPressed: controller.reset,
    );
  }

  Widget _buildSpeedSelector() {
    return ValueListenableBuilder<double>(
      valueListenable: controller.speedNotifier,
      builder: (context, speed, child) {
        return DropdownButton<double>(
          value: speed,
          items: controller.availableSpeeds
              .map((speed) => DropdownMenuItem(
                    value: speed,
                    child: Text('${speed}x'),
                  ))
              .toList(),
          onChanged: (newSpeed) {
            if (newSpeed != null) {
              controller.speed = newSpeed;
            }
          },
        );
      },
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }
}

/// A widget that displays a seek bar for the playback timer
class PlaybackSeekBarWidget extends StatelessWidget {
  /// Controller for the playback timer
  final PlaybackTimerController controller;

  /// Callback for when seek position changes
  final ValueChanged<Duration>? onSeekChanged;

  /// Creates a PlaybackSeekBarWidget
  const PlaybackSeekBarWidget({
    super.key,
    required this.controller,
    this.onSeekChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Duration>(
      valueListenable: controller.currentPosition,
      builder: (context, currentPosition, child) {
        return Slider(
          value: currentPosition.inMilliseconds.toDouble(),
          max: controller.totalDuration.inMilliseconds.toDouble(),
          onChanged: (value) {
            final newPosition = Duration(milliseconds: value.round());
            controller.seek(newPosition);
            onSeekChanged?.call(newPosition);
          },
        );
      },
    );
  }
}
