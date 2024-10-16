// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_setting_use_case_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$saveSettingUseCaseHash() =>
    r'e742e2d15547b45300640da0eca4d488dfa16e04';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [saveSettingUseCase].
@ProviderFor(saveSettingUseCase)
const saveSettingUseCaseProvider = SaveSettingUseCaseFamily();

/// See also [saveSettingUseCase].
class SaveSettingUseCaseFamily extends Family {
  /// See also [saveSettingUseCase].
  const SaveSettingUseCaseFamily();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'saveSettingUseCaseProvider';

  /// See also [saveSettingUseCase].
  SaveSettingUseCaseProvider call(
    Setting setting,
  ) {
    return SaveSettingUseCaseProvider(
      setting,
    );
  }

  @visibleForOverriding
  @override
  SaveSettingUseCaseProvider getProviderOverride(
    covariant SaveSettingUseCaseProvider provider,
  ) {
    return call(
      provider.setting,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(
      FutureOr<void> Function(SaveSettingUseCaseRef ref) create) {
    return _$SaveSettingUseCaseFamilyOverride(this, create);
  }
}

class _$SaveSettingUseCaseFamilyOverride implements FamilyOverride {
  _$SaveSettingUseCaseFamilyOverride(this.overriddenFamily, this.create);

  final FutureOr<void> Function(SaveSettingUseCaseRef ref) create;

  @override
  final SaveSettingUseCaseFamily overriddenFamily;

  @override
  SaveSettingUseCaseProvider getProviderOverride(
    covariant SaveSettingUseCaseProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [saveSettingUseCase].
class SaveSettingUseCaseProvider extends AutoDisposeFutureProvider<void> {
  /// See also [saveSettingUseCase].
  SaveSettingUseCaseProvider(
    Setting setting,
  ) : this._internal(
          (ref) => saveSettingUseCase(
            ref as SaveSettingUseCaseRef,
            setting,
          ),
          from: saveSettingUseCaseProvider,
          name: r'saveSettingUseCaseProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$saveSettingUseCaseHash,
          dependencies: SaveSettingUseCaseFamily._dependencies,
          allTransitiveDependencies:
              SaveSettingUseCaseFamily._allTransitiveDependencies,
          setting: setting,
        );

  SaveSettingUseCaseProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.setting,
  }) : super.internal();

  final Setting setting;

  @override
  Override overrideWith(
    FutureOr<void> Function(SaveSettingUseCaseRef ref) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SaveSettingUseCaseProvider._internal(
        (ref) => create(ref as SaveSettingUseCaseRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        setting: setting,
      ),
    );
  }

  @override
  (Setting,) get argument {
    return (setting,);
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _SaveSettingUseCaseProviderElement(this);
  }

  SaveSettingUseCaseProvider _copyWith(
    FutureOr<void> Function(SaveSettingUseCaseRef ref) create,
  ) {
    return SaveSettingUseCaseProvider._internal(
      (ref) => create(ref as SaveSettingUseCaseRef),
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      setting: setting,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SaveSettingUseCaseProvider && other.setting == setting;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, setting.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SaveSettingUseCaseRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `setting` of this provider.
  Setting get setting;
}

class _SaveSettingUseCaseProviderElement
    extends AutoDisposeFutureProviderElement<void> with SaveSettingUseCaseRef {
  _SaveSettingUseCaseProviderElement(super.provider);

  @override
  Setting get setting => (origin as SaveSettingUseCaseProvider).setting;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
