import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:coach_app/core/theme/app_colors.dart';
import 'package:coach_app/core/theme/app_text_style.dart';
import 'package:coach_app/core/widgets/autocomplete_selector.dart';
import 'package:coach_app/core/widgets/form_label.dart';
import 'package:coach_app/features/athletes/presentation/models/sport_view.dart';
import 'package:coach_app/features/athletes/presentation/providers/sport_view_model.dart';
import 'package:coach_app/features/sessions/presentation/models/session_view.dart';
import 'package:coach_app/features/sessions/presentation/providers/session_form_provider.dart';
import 'package:coach_app/l10n.dart';
import 'package:coach_app/shared/extensions/date_time.dart';

/// A form for editing session details
class SessionDetailsForm extends ConsumerWidget {
  /// Creates a [SessionDetailsForm]
  const SessionDetailsForm({
    super.key,
    required this.formKey,
    required this.session,
  });

  /// Global key for the form
  final GlobalKey<FormState> formKey;

  /// The session being edited
  final SessionView session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionForm =
        ref.watch(sessionFormProvider(initialSession: session).notifier);
    final sessionFormState =
        ref.watch(sessionFormProvider(initialSession: session));

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FormLabel(
            label: '${context.l10n.sessionTitle} *',
            child: TextFormField(
              initialValue: sessionFormState.title,
              decoration: InputDecoration(hintText: context.l10n.sessionTitle),
              validator: (value) => value?.isEmpty ?? true
                  ? context.l10n.pleaseEnterSessionTitle
                  : null,
              style: AppTextStyle.primary16r.copyWith(color: AppColors.black),
              onChanged: sessionForm.setTitle,
            ),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () async {
              final pickedDate = await showDatePicker(
                context: context,
                initialDate: sessionFormState.date ?? session.startTime,
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
              );
              if (pickedDate != null) {
                sessionForm.setDate(pickedDate);
              }
            },
            child: FormLabel(
              label: '${context.l10n.date} *',
              child: InputDecorator(
                decoration: InputDecoration(hintText: context.l10n.date),
                child: Text(
                  (sessionFormState.date ?? session.startTime)
                      .formatForLocale(context),
                  style:
                      AppTextStyle.primary16r.copyWith(color: AppColors.black),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _SportsField(session: session),
        ],
      ),
    );
  }
}

/// Widget for the sports input field and chip list
class _SportsField extends ConsumerWidget {
  final SessionView? session;

  const _SportsField({required this.session});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSport = ref.watch(sessionFormProvider(initialSession: session)
            .select((state) => state.sport)) ??
        session?.sport;

    return FormLabel(
      label: '${context.l10n.sport} *',
      child: AutocompleteSelector<SportView>(
        onItemSelected: (sport) => ref
            .read(sessionFormProvider(initialSession: session).notifier)
            .setSport(sport),
        itemsProvider: sportViewModelProvider,
        labelBuilder: (sport) => sport.name,
        filterOption: (sport, query) =>
            sport.name.toLowerCase().contains(query.toLowerCase()),
        hintText: context.l10n.selectSport,
        selectedItems: selectedSport != null ? [selectedSport] : [],
        multiSelect: false,
      ),
    );
  }
}
