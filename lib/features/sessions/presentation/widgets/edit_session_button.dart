import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:coach_app/core/theme/app_text_style.dart';
import 'package:coach_app/core/widgets/primary_button.dart';
import 'package:coach_app/features/sessions/presentation/models/session_view.dart';
import 'package:coach_app/features/sessions/presentation/pages/session_details_form.dart';
import 'package:coach_app/features/sessions/presentation/providers/session_form_provider.dart';
import 'package:coach_app/features/sessions/presentation/providers/session_view_model_provider.dart';
import 'package:coach_app/features/sessions/presentation/providers/sessions_view_model_provider.dart';
import 'package:coach_app/l10n.dart';
import 'package:coach_app/shared/extensions/context.dart';

/// A button that opens a drawer or bottom sheet for editing a session
class EditSessionButton extends ConsumerWidget {
  /// Creates an EditSessionButton
  const EditSessionButton({
    super.key,
    required this.session,
    required this.child,
    this.hasDrawer = false,
  });

  /// The session to be edited
  final SessionView session;

  /// The child widget to be displayed as the button content
  final Widget child;

  /// Whether to show a drawer instead of a dialog on desktop
  final bool hasDrawer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        if (context.isDesktop) {
          if (hasDrawer) {
            _showEditDrawer(context, ref);
          } else {
            _showDialog(context, ref);
          }
        } else {
          _showBottomSheet(context, ref);
        }
      },
      child: child,
    );
  }

  /// Shows a bottom sheet for editing on mobile devices
  void _showBottomSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.color.tertiary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (_, controller) {
            return EditSessionContent(
              session: session,
              scrollController: controller,
              ref: ref,
            );
          },
        );
      },
    );
  }

  /// Shows a dialog for editing on desktop devices
  void _showDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: SizedBox(
            width: 520,
            child: EditSessionContent(
              session: session,
              ref: ref,
            ),
          ),
        );
      },
    );
  }

  /// Opens the end drawer for editing
  void _showEditDrawer(BuildContext context, WidgetRef ref) {
    Scaffold.of(context).openEndDrawer();
  }
}

/// Content widget for editing a session
class EditSessionContent extends StatelessWidget {
  /// Creates an EditSessionContent widget
  const EditSessionContent({
    super.key,
    required this.session,
    this.scrollController,
    required this.ref,
  });

  /// The session being edited
  final SessionView session;

  /// ScrollController for the content, if needed
  final ScrollController? scrollController;

  /// WidgetRef for accessing providers
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return SingleChildScrollView(
      controller: scrollController,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.l10n.editSession,
                  style: AppTextStyle.primary26b,
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SessionDetailsForm(
              formKey: formKey,
              session: session,
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                onPressed: () => _onSaveSessionPressed(context, formKey),
                label: context.l10n.save,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Handles the save button press
  void _onSaveSessionPressed(
      BuildContext context, GlobalKey<FormState> formKey) async {
    if (formKey.currentState!.validate()) {
      final formNotifier =
          ref.read(sessionFormProvider(initialSession: session).notifier);
      final result = await formNotifier.update(session);

      if (result.isSuccess) {
        context.showSnackbar(
          context.l10n.sessionUpdated,
          showCheckIcon: true,
        );
        Navigator.of(context).pop(); // Close the drawer or bottom sheet
        ref
            .read(sessionViewModelProvider(session.id).notifier)
            .fetchSession(session.id);
        ref.read(sessionsViewModelProvider(null).notifier).refresh();
      } else {
        context.showSnackbar(
          '${context.l10n.failedToUpdateSession}: ${result.error}',
        );
      }
    }
  }
}
