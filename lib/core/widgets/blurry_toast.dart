import 'dart:io';
import 'dart:ui';

import 'package:coach_app/core/theme/app_colors.dart';
import 'package:coach_app/core/theme/app_text_style.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

/// A customizable toast widget with a blurred background effect.
///
/// This widget displays a message with a close button on a semi-transparent,
/// blurred background. It's designed to be used with [showBlurryToast] for
/// temporary notifications in the app.
class BlurryToast extends StatelessWidget {
  /// The message to display in the toast.
  final String message;

  /// Callback function to be called when the dismiss button is tapped.
  final VoidCallback onDismiss;

  /// Creates a [BlurryToast] widget.
  ///
  /// The [message] parameter is required and specifies the text to be displayed.
  /// The [onDismiss] parameter is a required callback for handling the dismiss action.
  const BlurryToast({
    super.key,
    required this.message,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.grey300.withOpacity(.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    message,
                    style: AppTextStyle.primary14r,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 20),
                onPressed: onDismiss,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A widget that applies a fade-in animation to its child.
///
/// This widget is used to animate the appearance of the [BlurryToast].
class FadeInToast extends StatefulWidget {
  /// The widget to be animated.
  final Widget child;

  /// The duration of the fade-in animation.
  final Duration duration;

  /// Creates a [FadeInToast] widget.
  ///
  /// The [child] parameter is required and specifies the widget to be animated.
  /// The [duration] parameter defaults to 300 milliseconds if not specified.
  const FadeInToast({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  State<FadeInToast> createState() => _FadeInToastState();
}

class _FadeInToastState extends State<FadeInToast>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: widget.child,
    );
  }
}

/// Shows a blurry toast notification at the top of the screen.
///
/// This function creates and displays a [BlurryToast] widget with the given [message].
/// The toast automatically dismisses after 3 seconds.
///
/// [context] is used to access the overlay and media query data.
/// [message] is the text to be displayed in the toast.
void showBlurryToast(BuildContext context, String message) {
  final overlay = Overlay.of(context);
  OverlayEntry? entry;

  entry = OverlayEntry(
    builder: (context) => Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      left: 16,
      right: 16,
      child: Material(
        color: Colors.transparent,
        child: Align(
          alignment: Alignment.topCenter,
          child: FadeInToast(
            child: BlurryToast(
              message: message,
              onDismiss: () {
                entry?.remove();
              },
            ),
          ),
        ),
      ),
    ),
  );

  overlay.insert(entry);

  // Auto-dismiss after 3 seconds with fade out animation
// Skip auto-dismiss in test mode
  if (!kIsWeb && !Platform.environment.containsKey('FLUTTER_TEST')) {
    Future.delayed(const Duration(seconds: 3), () {
      if (entry?.mounted ?? false) {
        entry?.remove();
      }
    });
  }
}
