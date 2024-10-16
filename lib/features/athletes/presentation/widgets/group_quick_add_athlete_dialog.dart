import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:coach_app/core/widgets/app_dialog.dart';
import 'package:coach_app/core/widgets/blurry_toast.dart';
import 'package:coach_app/features/athletes/presentation/providers/athlete_form_provider.dart';
import 'package:coach_app/features/athletes/presentation/widgets/athlete_avatar_upload.dart';
import 'package:coach_app/features/athletes/presentation/widgets/athlete_details_form.dart';
import 'package:coach_app/l10n.dart';
import 'package:coach_app/shared/extensions/context.dart';

class GroupQuickAddAthleteDialog extends StatelessWidget {
  GroupQuickAddAthleteDialog({
    super.key,
    this.athleteName,
  });
  final String? athleteName;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: context.l10n.addAthlete,
      content: Column(
        children: [
          const AthleteAvatarUpload(),
          AthleteDetailsForm(
            formKey: _formKey,
            athleteName: athleteName,
          ),
        ],
      ),
      actions: [
        OutlinedButton(
          onPressed: Navigator.of(context).pop,
          child: Text(context.l10n.cancel),
        ),
        const SizedBox(height: 16, width: 16),
        Consumer(
          builder: (context, ref, child) {
            final formNotifier = ref.watch(athleteFormProvider.notifier);
            final formState = ref.watch(athleteFormProvider);

            return ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate() && formState.isValid()) {
                  final result = await formNotifier.saveAthlete();
                  if (result.isSuccess) {
                    showBlurryToast(context, context.l10n.athleteAdded);
                    Navigator.of(context).pop(result.value);
                  } else {
                    context.showSnackbar(
                        '${context.l10n.failedToAddAthlete}: ${result.error}');
                  }
                } else {
                  showBlurryToast(context, context.l10n.fillRequiredFields);
                }
              },
              child: Text(context.l10n.addAthlete),
            );
          },
        ),
      ],
    );
  }
}
