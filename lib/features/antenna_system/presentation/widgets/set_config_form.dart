import 'package:coach_app/core/theme/app_colors.dart';
import 'package:coach_app/core/theme/app_text_style.dart';
import 'package:coach_app/core/widgets/form_label.dart';
import 'package:coach_app/features/antenna_system/presentation/view_model/set_config_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coach_app/l10n.dart';

class SetConfigForm extends ConsumerStatefulWidget {
  final Function(SetConfigData) onSubmit;

  const SetConfigForm({super.key, required this.onSubmit});

  @override
  SetConfigFormState createState() => SetConfigFormState();
}

class SetConfigFormState extends ConsumerState<SetConfigForm> {
  final _formKey = GlobalKey<FormState>();
  late int _masterId;
  late int _frequency;
  late int _mainFrequency;
  late bool _isMain;
  late int _clubId;

  @override
  void initState() {
    super.initState();
    _masterId = 1;
    _frequency = 24;
    _mainFrequency = 0;
    _isMain = true;
    _clubId = 1;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FormLabel(
            label: context.l10n.masterId,
            child: TextFormField(
              keyboardType: TextInputType.number,
              initialValue: _masterId.toString(),
              style: AppTextStyle.primary16r.copyWith(color: AppColors.black),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return context.l10n.pleaseEnterValue;
                }
                if (int.tryParse(value) == null) {
                  return context.l10n.pleaseEnterValidNumber;
                }
                return null;
              },
              onSaved: (value) => _masterId = int.parse(value!),
            ),
          ),
          FormLabel(
            label: context.l10n.frequency,
            child: TextFormField(
              keyboardType: TextInputType.number,
              initialValue: _frequency.toString(),
              style: AppTextStyle.primary16r.copyWith(color: AppColors.black),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return context.l10n.pleaseEnterValue;
                }
                if (double.tryParse(value) == null) {
                  return context.l10n.pleaseEnterValidNumber;
                }
                return null;
              },
              onSaved: (value) => _frequency = int.parse(value!),
            ),
          ),
          FormLabel(
            label: context.l10n.mainFrequency,
            child: TextFormField(
              keyboardType: TextInputType.number,
              initialValue: _mainFrequency.toString(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return context.l10n.pleaseEnterValue;
                }
                if (double.tryParse(value) == null) {
                  return context.l10n.pleaseEnterValidNumber;
                }
                return null;
              },
              style: AppTextStyle.primary16r.copyWith(color: AppColors.black),
              onSaved: (value) => _mainFrequency = int.parse(value!),
            ),
          ),
          SwitchListTile(
            title: Text(context.l10n.isMain),
            value: _isMain,
            onChanged: (bool value) {
              setState(() {
                _isMain = value;
              });
            },
          ),
          FormLabel(
            label: context.l10n.clubId,
            child: TextFormField(
              keyboardType: TextInputType.number,
              initialValue: _clubId.toString(),
              style: AppTextStyle.primary16r.copyWith(color: AppColors.black),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return context.l10n.pleaseEnterValue;
                }
                if (int.tryParse(value) == null) {
                  return context.l10n.pleaseEnterValidNumber;
                }
                return null;
              },
              onSaved: (value) => _clubId = int.parse(value!),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  widget.onSubmit(SetConfigData(
                    masterId: _masterId,
                    frequency: _frequency,
                    mainFrequency: _mainFrequency,
                    isMain: _isMain,
                    clubId: _clubId,
                  ));
                }
              },
              child: Text(context.l10n.submit),
            ),
          ),
        ],
      ),
    );
  }
}
