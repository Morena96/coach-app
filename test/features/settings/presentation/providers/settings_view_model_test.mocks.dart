// Mocks generated by Mockito 5.4.4 from annotations
// in coach_app/test/features/settings/presentation/providers/settings_view_model_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:application/settings/use_cases/get_all_settings_use_case.dart'
    as _i2;
import 'package:application/settings/use_cases/get_setting_use_case.dart'
    as _i5;
import 'package:application/settings/use_cases/save_setting_use_case.dart'
    as _i6;
import 'package:domain/features/settings/entities/setting.dart' as _i4;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

/// A class which mocks [GetAllSettingsUseCase].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetAllSettingsUseCase extends _i1.Mock
    implements _i2.GetAllSettingsUseCase {
  MockGetAllSettingsUseCase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<List<_i4.Setting>> execute() => (super.noSuchMethod(
        Invocation.method(
          #execute,
          [],
        ),
        returnValue: _i3.Future<List<_i4.Setting>>.value(<_i4.Setting>[]),
      ) as _i3.Future<List<_i4.Setting>>);
}

/// A class which mocks [GetSettingUseCase].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetSettingUseCase extends _i1.Mock implements _i5.GetSettingUseCase {
  MockGetSettingUseCase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<_i4.Setting?> execute(String? key) => (super.noSuchMethod(
        Invocation.method(
          #execute,
          [key],
        ),
        returnValue: _i3.Future<_i4.Setting?>.value(),
      ) as _i3.Future<_i4.Setting?>);
}

/// A class which mocks [SaveSettingUseCase].
///
/// See the documentation for Mockito's code generation for more information.
class MockSaveSettingUseCase extends _i1.Mock
    implements _i6.SaveSettingUseCase {
  MockSaveSettingUseCase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<void> execute(_i4.Setting? setting) => (super.noSuchMethod(
        Invocation.method(
          #execute,
          [setting],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
}
