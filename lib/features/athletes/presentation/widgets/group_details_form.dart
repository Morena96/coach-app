import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:flutter/material.dart';

import 'package:coach_app/core/theme/app_colors.dart';
import 'package:coach_app/core/theme/app_text_style.dart';
import 'package:coach_app/core/widgets/autocomplete_selector.dart';
import 'package:coach_app/core/widgets/form_label.dart';
import 'package:coach_app/features/athletes/presentation/models/sport_view.dart';
import 'package:coach_app/features/athletes/presentation/providers/group_form_provider.dart';
import 'package:coach_app/features/athletes/presentation/providers/sport_view_model.dart';
import 'package:coach_app/l10n.dart';
import 'package:coach_app/shared/utils/app_validator.dart';

class GroupDetailsForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  const GroupDetailsForm({super.key, required this.formKey});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _NameField(),
          SizedBox(height: 16),
          _SportField(),
          SizedBox(height: 16),
          _DescriptionField(),
        ],
      ),
    );
  }
}

/// Widget for the full name input field
class _NameField extends ConsumerStatefulWidget {
  const _NameField();

  @override
  _FullNameFieldState createState() => _FullNameFieldState();
}

class _FullNameFieldState extends ConsumerState<_NameField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final groupName =
        ref.watch(groupFormProvider.select((state) => state.name));
    final formNotifier = ref.read(groupFormProvider.notifier);

    // Update controller when fullName changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_controller.text != groupName) {
        _controller.text = groupName ?? '';
      }
    });

    return FormLabel(
      label: '${context.l10n.groupName} *',
      child: TextFormField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: context.l10n.enterGroupsFullName,
        ),
        onChanged: (value) => formNotifier.setName(value),
        style: AppTextStyle.primary16r.copyWith(color: AppColors.black),
        validator:
            AppValidator.nonEmptyString(context.l10n.pleaseEnterGroupsName),
      ),
    );
  }
}

/// Widget for the sports input field and chip list
class _SportField extends ConsumerWidget {
  /// Widget for selecting a sport in the group form
  const _SportField();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSport =
        ref.watch(groupFormProvider.select((state) => state.sport));
    return FormLabel(
      label: '${context.l10n.sport} *',
      child: AutocompleteSelector<SportView>(
        onItemSelected: (sport) =>
            ref.read(groupFormProvider.notifier).setSport(sport),
        itemsProvider: sportViewModelProvider,
        labelBuilder: (sport) => sport.name,
        filterOption: (sport, query) =>
            sport.name.toLowerCase().contains(query.toLowerCase()),
        hintText: context.l10n.selectGroupsSport,
        selectedItems: selectedSport != null ? [selectedSport] : [],
        multiSelect: false,
      ),
    );
  }
}

/// Widget for the name input field
class _DescriptionField extends ConsumerStatefulWidget {
  const _DescriptionField();

  @override
  _DescriptionFieldState createState() => _DescriptionFieldState();
}

class _DescriptionFieldState extends ConsumerState<_DescriptionField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final description =
        ref.watch(groupFormProvider.select((state) => state.description));
    final formNotifier = ref.read(groupFormProvider.notifier);

    // Update controller when fullName changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_controller.text != description) {
        _controller.text = description ?? '';
      }
    });

    return FormLabel(
      label: context.l10n.description,
      child: TextFormField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: context.l10n.enterGroupsDescription,
        ),
        minLines: 4,
        maxLines: 6,
        maxLength: 320,
        onChanged: (value) => formNotifier.setDescription(value),
        style: AppTextStyle.primary16r.copyWith(color: AppColors.black),
      ),
    );
  }
}
