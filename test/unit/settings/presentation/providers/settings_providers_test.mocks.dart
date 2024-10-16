// Mocks generated by Mockito 5.4.4 from annotations
// in coach_app/test/unit/settings/presentation/providers/settings_providers_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:coach_app/features/settings/infrastructure/datasources/hive_settings_data_source.dart'
    as _i5;
import 'package:coach_app/features/settings/infrastructure/repositories/settings_repository_impl.dart'
    as _i2;
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

/// A class which mocks [SettingsRepositoryImpl].
///
/// See the documentation for Mockito's code generation for more information.
class MockSettingsRepositoryImpl extends _i1.Mock
    implements _i2.SettingsRepositoryImpl {
  MockSettingsRepositoryImpl() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<List<_i4.Setting>> getAllSettings() => (super.noSuchMethod(
        Invocation.method(
          #getAllSettings,
          [],
        ),
        returnValue: _i3.Future<List<_i4.Setting>>.value(<_i4.Setting>[]),
      ) as _i3.Future<List<_i4.Setting>>);

  @override
  _i3.Future<_i4.Setting?> getSettingByKey(String? key) => (super.noSuchMethod(
        Invocation.method(
          #getSettingByKey,
          [key],
        ),
        returnValue: _i3.Future<_i4.Setting?>.value(),
      ) as _i3.Future<_i4.Setting?>);

  @override
  _i3.Future<void> saveSetting(_i4.Setting? setting) => (super.noSuchMethod(
        Invocation.method(
          #saveSetting,
          [setting],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> deleteSetting(String? key) => (super.noSuchMethod(
        Invocation.method(
          #deleteSetting,
          [key],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
}

/// A class which mocks [HiveSettingsDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockHiveSettingsDataSource extends _i1.Mock
    implements _i5.HiveSettingsDataSource {
  MockHiveSettingsDataSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<List<Map<String, dynamic>>> getAllSettings() =>
      (super.noSuchMethod(
        Invocation.method(
          #getAllSettings,
          [],
        ),
        returnValue: _i3.Future<List<Map<String, dynamic>>>.value(
            <Map<String, dynamic>>[]),
      ) as _i3.Future<List<Map<String, dynamic>>>);

  @override
  _i3.Future<Map<String, dynamic>?> getSettingByKey(String? key) =>
      (super.noSuchMethod(
        Invocation.method(
          #getSettingByKey,
          [key],
        ),
        returnValue: _i3.Future<Map<String, dynamic>?>.value(),
      ) as _i3.Future<Map<String, dynamic>?>);

  @override
  _i3.Future<void> saveSetting(Map<String, dynamic>? settingMap) =>
      (super.noSuchMethod(
        Invocation.method(
          #saveSetting,
          [settingMap],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> deleteSetting(String? key) => (super.noSuchMethod(
        Invocation.method(
          #deleteSetting,
          [key],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
}
