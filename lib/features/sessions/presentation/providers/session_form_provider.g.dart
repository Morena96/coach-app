// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_form_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sessionFormHash() => r'2da75ecd5959c07a3b2f0a03be438a75d854f68c';

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

abstract class _$SessionForm
    extends BuildlessAutoDisposeNotifier<SessionFormState> {
  late final SessionView? initialSession;

  SessionFormState build({
    SessionView? initialSession,
  });
}

/// Manages the state and logic for the session form
///
/// Copied from [SessionForm].
@ProviderFor(SessionForm)
const sessionFormProvider = SessionFormFamily();

/// Manages the state and logic for the session form
///
/// Copied from [SessionForm].
class SessionFormFamily extends Family {
  /// Manages the state and logic for the session form
  ///
  /// Copied from [SessionForm].
  const SessionFormFamily();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'sessionFormProvider';

  /// Manages the state and logic for the session form
  ///
  /// Copied from [SessionForm].
  SessionFormProvider call({
    SessionView? initialSession,
  }) {
    return SessionFormProvider(
      initialSession: initialSession,
    );
  }

  @visibleForOverriding
  @override
  SessionFormProvider getProviderOverride(
    covariant SessionFormProvider provider,
  ) {
    return call(
      initialSession: provider.initialSession,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(SessionForm Function() create) {
    return _$SessionFormFamilyOverride(this, create);
  }
}

class _$SessionFormFamilyOverride implements FamilyOverride {
  _$SessionFormFamilyOverride(this.overriddenFamily, this.create);

  final SessionForm Function() create;

  @override
  final SessionFormFamily overriddenFamily;

  @override
  SessionFormProvider getProviderOverride(
    covariant SessionFormProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// Manages the state and logic for the session form
///
/// Copied from [SessionForm].
class SessionFormProvider
    extends AutoDisposeNotifierProviderImpl<SessionForm, SessionFormState> {
  /// Manages the state and logic for the session form
  ///
  /// Copied from [SessionForm].
  SessionFormProvider({
    SessionView? initialSession,
  }) : this._internal(
          () => SessionForm()..initialSession = initialSession,
          from: sessionFormProvider,
          name: r'sessionFormProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$sessionFormHash,
          dependencies: SessionFormFamily._dependencies,
          allTransitiveDependencies:
              SessionFormFamily._allTransitiveDependencies,
          initialSession: initialSession,
        );

  SessionFormProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.initialSession,
  }) : super.internal();

  final SessionView? initialSession;

  @override
  SessionFormState runNotifierBuild(
    covariant SessionForm notifier,
  ) {
    return notifier.build(
      initialSession: initialSession,
    );
  }

  @override
  Override overrideWith(SessionForm Function() create) {
    return ProviderOverride(
      origin: this,
      override: SessionFormProvider._internal(
        () => create()..initialSession = initialSession,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        initialSession: initialSession,
      ),
    );
  }

  @override
  ({
    SessionView? initialSession,
  }) get argument {
    return (initialSession: initialSession,);
  }

  @override
  AutoDisposeNotifierProviderElement<SessionForm, SessionFormState>
      createElement() {
    return _SessionFormProviderElement(this);
  }

  SessionFormProvider _copyWith(
    SessionForm Function() create,
  ) {
    return SessionFormProvider._internal(
      () => create()..initialSession = initialSession,
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      initialSession: initialSession,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SessionFormProvider &&
        other.initialSession == initialSession;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, initialSession.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SessionFormRef on AutoDisposeNotifierProviderRef<SessionFormState> {
  /// The parameter `initialSession` of this provider.
  SessionView? get initialSession;
}

class _SessionFormProviderElement
    extends AutoDisposeNotifierProviderElement<SessionForm, SessionFormState>
    with SessionFormRef {
  _SessionFormProviderElement(super.provider);

  @override
  SessionView? get initialSession =>
      (origin as SessionFormProvider).initialSession;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
