import 'dart:ui';

import 'package:coach_app/core/widgets/app_divider.dart';
import 'package:coach_app/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:coach_app/core/theme/app_text_style.dart';
import 'package:coach_app/shared/extensions/context.dart';

enum ActionsDirection { vertical, horizontal }

/// A responsive custom dialog widget that displays a title, content, and actions.
///
/// This dialog provides a consistent layout with a title at the top,
/// custom content in the middle, and action buttons at the bottom.
/// It also includes a close button in the top-right corner.
///
/// The dialog has a fixed width of 460 on non-mobile devices and uses the app's color scheme.
///
/// On mobile devices, this widget is displayed as a modal bottom sheet instead of a dialog.
///
/// Example usage:
/// ```dart
/// showDialogOrModal(
///   context: context,
///   builder: (context) => AppDialog(
///     title: 'Confirmation',
///     content: Text('Are you sure you want to proceed?'),
///     actions: [
///       ElevatedButton(
///         onPressed: () => Navigator.of(context).pop(),
///         child: Text('Cancel'),
///       ),
///       ElevatedButton(
///         onPressed: () {
///           // Perform action
///           Navigator.of(context).pop();
///         },
///         child: Text('Confirm'),
///       ),
///     ],
///   ),
/// );
/// ```
class AppDialog extends StatelessWidget {
  /// Creates an AppDialog.
  ///
  /// The [title], [content], and [actions] parameters must not be null.
  const AppDialog({
    super.key,
    required this.title,
    required this.content,
    required this.actions,
    this.actionsDirection = ActionsDirection.vertical,
    this.centerTitle = true,
    this.titleDivider = false,
    this.forceDialog = false,
  });

  /// The title of the dialog, displayed at the top.
  final String title;

  /// The main content of the dialog.
  final Widget content;

  /// A list of widgets to display as action buttons at the bottom of the dialog.
  final List<Widget> actions;

  final ActionsDirection actionsDirection;
  final bool centerTitle;
  final bool titleDivider;

  /// This widget will be dialog for desktop and bottom sheet for mobile.
  /// Pass this parameter as true for showing dialog on mobile as well.
  final bool forceDialog;

  bool showAsDialog(BuildContext context) => !context.isMobile || forceDialog;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: showAsDialog(context)
          ? Dialog(
              backgroundColor: Colors.transparent,
              child: Stack(
                children: [
                  Container(
                    width: 460,
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    decoration: BoxDecoration(
                      color: context.color.tertiary,
                      borderRadius: showAsDialog(context)
                          ? BorderRadius.circular(16)
                          : const BorderRadius.vertical(
                              top: Radius.circular(16)),
                      border: Border.all(
                        color: context.color.onSurface.withOpacity(.14),
                      ),
                    ),
                    child: _buildChild(context),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: IconButton(
                      key: const Key('dialog_close_button'),
                      onPressed: () => Navigator.of(context).pop(),
                      icon: SvgPicture.asset('assets/icons/close.svg'),
                    ),
                  )
                ],
              ),
            )
          : _FullScreenDialog(
              title: title,
              content: _buildChild(context),
            ),
    );
  }

  Widget _buildChild(BuildContext context) {
    final isMobile = context.isMobile;
    final padding =
        EdgeInsets.symmetric(horizontal: context.isMobile ? 20 : 40);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!isMobile)
          Container(
            padding: padding,
            margin: const EdgeInsets.only(bottom: 12),
            alignment: centerTitle ? Alignment.center : Alignment.centerLeft,
            child: Text(title, style: AppTextStyle.primary20b),
          ),
        // const SizedBox(height: 12),
        if (titleDivider) ...[
          const AppDivider(),
          const SizedBox(height: 12),
        ],
        Padding(
          padding: padding,
          child: content,
        ),
        const SizedBox(height: 40),
        Padding(
          padding: padding,
          child: actionsDirection == ActionsDirection.vertical || isMobile
              ? Column(
                  children: actions
                      .map((action) =>
                          SizedBox(width: double.infinity, child: action))
                      .toList(),
                )
              : Row(children: actions),
        ),
      ],
    );
  }
}

class _FullScreenDialog extends StatelessWidget {
  const _FullScreenDialog({
    required this.title,
    required this.content,
  });
  final String title;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: content,
    );
  }
}

/// A customizable confirmation dialog widget.
///
/// This dialog presents a message to the user and provides two action buttons:
/// one for confirming the action (positive) and another for canceling.
class AppConfirmDialog extends StatelessWidget {
  const AppConfirmDialog({
    super.key,
    required this.content,
    required this.positiveLabel,
  });
  final String content;
  final String positiveLabel;

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: context.l10n.areYouSure,
      forceDialog: true,
      content: Padding(
        padding: EdgeInsets.only(top: context.isMobile ? 26 : 0),
        child: Text(
          content,
          style: AppTextStyle.secondary14r,
          textAlign: TextAlign.center,
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(
            positiveLabel,
            style: AppTextStyle.primary14b,
          ),
        ),
        const SizedBox(height: 20),
        OutlinedButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            context.l10n.cancel,
            style: AppTextStyle.secondary14r,
          ),
        )
      ],
    );
  }
}
