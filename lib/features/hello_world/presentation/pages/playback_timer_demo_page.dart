import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:coach_app/core/widgets/playback_timer_widget.dart';

/// Demo page for the PlaybackTimerWidget
class PlaybackTimerDemoPage extends StatefulWidget {
  const PlaybackTimerDemoPage({super.key});

  @override
  State<PlaybackTimerDemoPage> createState() => _PlaybackTimerDemoPageState();
}

class _PlaybackTimerDemoPageState extends State<PlaybackTimerDemoPage> {
  late PlaybackTimerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PlaybackTimerController(
      totalDuration: const Duration(minutes: 5),
      availableSpeeds: [0.5, 1.0, 1.5, 2.0],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Playback Timer Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PlaybackTimerWidget(
              controller: _controller,
            ),
            const SizedBox(height: 20),
            PlaybackSeekBarWidget(
              controller: _controller,
              onSeekChanged: (newPosition) {
                if (kDebugMode) {
                  print('Seeked to: ${newPosition.inSeconds} seconds');
                }
              },
            ),
            _buildControlInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildControlInfo() {
    return ValueListenableBuilder<Duration>(
      valueListenable: _controller.currentPosition,
      builder: (context, currentPosition, child) {
        return Column(
          children: [
            Text('Current Position: ${currentPosition.inSeconds} seconds'),
            Text(
                'Total Duration: ${_controller.totalDuration.inSeconds} seconds'),
            ValueListenableBuilder<bool>(
              valueListenable: _controller.isPlaying,
              builder: (context, isPlaying, child) {
                return Text('Is Playing: $isPlaying');
              },
            ),
            Text('Current Speed: ${_controller.speed}x'),
          ],
        );
      },
    );
  }
}
