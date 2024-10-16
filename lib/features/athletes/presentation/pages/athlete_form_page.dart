import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:coach_app/core/router/routes.dart';
import 'package:coach_app/core/widgets/blurry_toast.dart';
import 'package:coach_app/core/widgets/layout/bread_crumb_provider.dart';
import 'package:coach_app/core/widgets/layout/page_header.dart';
import 'package:coach_app/core/widgets/layout/page_layout.dart';
import 'package:coach_app/core/widgets/layout/vertical_tabs.dart';
import 'package:coach_app/features/athletes/presentation/models/athlete_view.dart';
import 'package:coach_app/features/athletes/presentation/providers/athlete_form_provider.dart';
import 'package:coach_app/features/athletes/presentation/providers/athlete_view_model_provider.dart';
import 'package:coach_app/features/athletes/presentation/providers/athletes_view_model.dart';
import 'package:coach_app/features/athletes/presentation/providers/athletes_view_model_provider.dart';
import 'package:coach_app/features/athletes/presentation/widgets/athlete_details_form.dart';
import 'package:coach_app/features/athletes/presentation/widgets/athlete_avatar_upload.dart';
import 'package:coach_app/features/avatars/infrastructure/provider/avatar_repository_provider.dart';
import 'package:coach_app/l10n.dart';
import 'package:coach_app/shared/extensions/context.dart';

/// A page for creating or editing an athlete's profile.
class AthleteFormPage extends ConsumerStatefulWidget {
  /// The athlete to edit. If null, a new athlete will be created.
  final AthleteView? athlete;

  /// Creates an [AthleteFormPage].
  ///
  /// If [athlete] is provided, the form will be in edit mode.
  const AthleteFormPage({super.key, this.athlete});

  @override
  ConsumerState<AthleteFormPage> createState() => _AthleteFormPageState();
}

/// The state for [AthleteFormPage].
class _AthleteFormPageState extends ConsumerState<AthleteFormPage>
    with SingleTickerProviderStateMixin {
  /// Key for the form to manage validation.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.athlete != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _initializeEditMode(widget.athlete!);
      });
    }
  }

  /// Initializes the form with existing athlete data for edit mode.
  ///
  /// Fetches and sets the athlete's name, sports, and avatar.
  Future<void> _initializeEditMode(AthleteView athlete) async {
    final formNotifier = ref.read(athleteFormProvider.notifier);
    formNotifier.setFullName(athlete.name);
    formNotifier.setSports(athlete.sports ?? []);

    if (athlete.avatarPath.isNotEmpty) {
      final avatarRepository = ref.read(avatarRepositoryProvider);
      final imageData =
          await avatarRepository.getAvatarImage(athlete.avatarPath);

      if (imageData != null) {
        formNotifier.setAvatar(imageData);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final formNotifier = ref.watch(athleteFormProvider.notifier);
    final formState = ref.watch(athleteFormProvider);
    final athletesViewModel = ref.read(athletesViewModelProvider.notifier);
    final isDesktop = context.width > 1000;
    final isEditMode = widget.athlete != null;

    return BreadcrumbProvider(
      customTitles: {
        '/athletes/${widget.athlete?.id}': widget.athlete?.name ?? '',
        '/athletes/${widget.athlete?.id}/edit': context.l10n.editAthlete,
        Routes.athletesCreate.path: context.l10n.addAthlete,
      },
      child: PageLayout(
        header: PageHeader(
          title:
              isEditMode ? context.l10n.editAthlete : context.l10n.addAthlete,
          actions: [
            if (isDesktop) ...[
              SizedBox(
                width: 180,
                child: OutlinedButton(
                  onPressed: Navigator.of(context).pop,
                  child: Text(context.l10n.cancel),
                ),
              ),
              const SizedBox(width: 16),
            ],
            SizedBox(
              width: isDesktop ? 180 : 130,
              child: ElevatedButton(
                onPressed: formState.isValid()
                    ? () => _onSaveAthletePressed(
                        formNotifier, formState, athletesViewModel, isEditMode)
                    : null,
                child: Text(
                    isEditMode ? context.l10n.save : context.l10n.addAthlete),
              ),
            )
          ],
        ),
        child: VerticalTabs(
          tabs: [
            VerticalTab(
              title: context.l10n.athletesDetails,
              paintIcon: !formState.isValid(),
              iconPath: formState.isValid()
                  ? 'assets/icons/check-mark-circle-filled.svg'
                  : 'assets/icons/check-mark-circle-outlined.svg',
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AthleteAvatarUpload(),
                  AthleteDetailsForm(
                    formKey: _formKey,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Handles the save button press.
  ///
  /// Validates the form, saves or updates the athlete, and shows appropriate feedback.
  void _onSaveAthletePressed(
      AthleteForm formNotifier,
      AthleteFormState formState,
      AthletesViewModel athletesViewModel,
      bool isEditMode) async {
    if (_formKey.currentState!.validate() && formState.isValid()) {
      final result = isEditMode
          ? await formNotifier.updateAthlete(widget.athlete!)
          : await formNotifier.saveAthlete();

      if (result.isSuccess) {
        context.showSnackbar(
          isEditMode ? context.l10n.athleteUpdated : context.l10n.athleteAdded,
          showCheckIcon: true,
        );

        // Reload AthletesListPage
        athletesViewModel.refresh();
        if (isEditMode) {
          // Reload AthleteViewPage
          ref
              .read(athleteViewModelProvider(widget.athlete!.id).notifier)
              .fetchAthlete(widget.athlete!.id);
        }

        Navigator.of(context).pop();
      } else {
        final message = isEditMode
            ? context.l10n.failedToUpdateAthlete
            : context.l10n.failedToAddAthlete;
        context.showSnackbar('$message: ${result.error}');
      }
    } else {
      showBlurryToast(context, context.l10n.fillRequiredFields);
    }
  }
}
