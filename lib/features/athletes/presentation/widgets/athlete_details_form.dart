import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:flutter/material.dart';

import 'package:coach_app/core/theme/app_colors.dart';
import 'package:coach_app/core/theme/app_text_style.dart';
import 'package:coach_app/core/widgets/autocomplete_selector.dart';
import 'package:coach_app/core/widgets/chip_list.dart';
import 'package:coach_app/core/widgets/form_label.dart';
import 'package:coach_app/features/athletes/presentation/models/sport_view.dart';
import 'package:coach_app/features/athletes/presentation/providers/athlete_form_provider.dart';
import 'package:coach_app/features/athletes/presentation/providers/sport_view_model.dart';
import 'package:coach_app/l10n.dart';
import 'package:coach_app/shared/extensions/context.dart';
import 'package:coach_app/shared/utils/app_validator.dart';

class AthleteDetailsForm extends ConsumerWidget {
  final GlobalKey<FormState> formKey;
  final String? athleteName;

  const AthleteDetailsForm(
      {super.key, required this.formKey, this.athleteName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FullNameField(athleteName: athleteName),
          const SizedBox(height: 16),
          _SportsField(),
        ],
      ),
    );
  }
}

/// Widget for the name input field
class _FullNameField extends ConsumerStatefulWidget {
  const _FullNameField({this.athleteName});
  final String? athleteName;

  @override
  _FullNameFieldState createState() => _FullNameFieldState();
}

class _FullNameFieldState extends ConsumerState<_FullNameField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.athleteName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fullName =
        ref.watch(athleteFormProvider.select((state) => state.fullName));
    final formNotifier = ref.read(athleteFormProvider.notifier);

    // Update controller when fullName changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.athleteName != null) {
        formNotifier.setFullName(widget.athleteName!);
      }
      if (_controller.text != fullName) {
        _controller.text = fullName ?? '';
      }
    });

    return FormLabel(
      label: '${context.l10n.fullName} *',
      child: TextFormField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: context.l10n.enterAthletesFullName,
        ),
        onChanged: (value) => formNotifier.setFullName(value),
        style: AppTextStyle.primary16r.copyWith(color: AppColors.black),
        validator: AppValidator.nonEmptyString(
            context.l10n.pleaseEnterAthletesFullName),
      ),
    );
  }
}

/// Widget for the sports input field and chip list
class _SportsField extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sports =
        ref.watch(athleteFormProvider.select((state) => state.sports));
    final formNotifier = ref.read(athleteFormProvider.notifier);

    return FormLabel(
      label: '${context.l10n.sport} *',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutocompleteSelector<SportView>(
            onItemSelected: (sport) => formNotifier.addSport(sport),
            itemsProvider: sportViewModelProvider,
            labelBuilder: (sport) => sport.name,
            filterOption: (sport, query) =>
                sport.name.toLowerCase().contains(query.toLowerCase()),
            hintText: context.l10n.enterAthletesSport,
            selectedItems: sports,
          ),
          const SizedBox(height: 22),
          ChipList<SportView>(
            items: sports,
            labelBuilder: (sport) => sport.name,
            onDeleted: (sport) => formNotifier.removeSport(sport),
            chipBackgroundColor: context.color.tertiary,
            chipBorderColor: context.color.onSurface.withOpacity(.14),
          ),
        ],
      ),
    );
  }
}
