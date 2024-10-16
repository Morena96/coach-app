import 'package:coach_app/shared/extensions/context.dart';
import 'package:flutter/material.dart';
import 'package:super_tooltip/super_tooltip.dart';

import 'package:coach_app/core/theme/app_text_style.dart';

/// A customizable tooltip widget that displays additional information when hovering over
/// or interacting with a child widget.
///
/// This widget wraps a [SuperTooltip] to provide an arrow-style tooltip with customizable
/// content and appearance.
class ArrowTooltip extends StatefulWidget {
  const ArrowTooltip({
    super.key,
    this.tooltipWidget,
    this.tooltipText,
    this.onInit,
    required this.child,
  }) : assert(tooltipWidget != null || tooltipText != null);

  /// A custom widget to be displayed in the tooltip.
  final Widget? tooltipWidget;

  /// The text to be displayed in the tooltip.
  final String? tooltipText;

  /// The widget that the tooltip will be attached to.
  final Widget child;

  /// A callback function that provides methods to programmatically show and hide the tooltip from parent
  ///
  /// This function is called during the initialization of the tooltip state and provides
  /// two functions as parameters:
  /// - `show`: A function to programmatically show the tooltip.
  /// - `hide`: A function to programmatically hide the tooltip.
  final Function(Function show, Function hide)? onInit;

  @override
  State<ArrowTooltip> createState() => _ArrowTooltipState();
}

class _ArrowTooltipState extends State<ArrowTooltip> {
  late SuperTooltipController controller;

  @override
  void initState() {
    super.initState();
    controller = SuperTooltipController();
    widget.onInit?.call(controller.showTooltip, controller.hideTooltip);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SuperTooltip(
      controller: controller,
      barrierColor: Colors.transparent,
      backgroundColor: context.color.onSurface,
      arrowLength: 7,
      arrowBaseWidth: 8,
      arrowTipDistance: 10,
      elevation: 0,
      hasShadow: false,
      content: widget.tooltipWidget ??
          Text(
            widget.tooltipText!,
            textAlign: TextAlign.center,
            style: AppTextStyle.primary12r.copyWith(
              color: context.color.surface,
            ),
          ),
      child: widget.child,
    );
  }
}
