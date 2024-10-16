// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'antenna_receive_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getAntennaDataStreamUseCaseHash() =>
    r'1be15615a271dcef9a1a88ccc3b23535b3dff408';

/// See also [getAntennaDataStreamUseCase].
@ProviderFor(getAntennaDataStreamUseCase)
final getAntennaDataStreamUseCaseProvider =
    Provider<GetAntennaDataStreamUseCase>.internal(
  getAntennaDataStreamUseCase,
  name: r'getAntennaDataStreamUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getAntennaDataStreamUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetAntennaDataStreamUseCaseRef
    = ProviderRef<GetAntennaDataStreamUseCase>;
String _$antennaDataStreamHash() => r'dbe810de022655832dc28d2b506dc9673d26ab02';

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

/// See also [antennaDataStream].
@ProviderFor(antennaDataStream)
const antennaDataStreamProvider = AntennaDataStreamFamily();

/// See also [antennaDataStream].
class AntennaDataStreamFamily extends Family {
  /// See also [antennaDataStream].
  const AntennaDataStreamFamily();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'antennaDataStreamProvider';

  /// See also [antennaDataStream].
  AntennaDataStreamProvider call(
    String portName,
  ) {
    return AntennaDataStreamProvider(
      portName,
    );
  }

  @visibleForOverriding
  @override
  AntennaDataStreamProvider getProviderOverride(
    covariant AntennaDataStreamProvider provider,
  ) {
    return call(
      provider.portName,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(
      Stream<List<String>> Function(AntennaDataStreamRef ref) create) {
    return _$AntennaDataStreamFamilyOverride(this, create);
  }
}

class _$AntennaDataStreamFamilyOverride implements FamilyOverride {
  _$AntennaDataStreamFamilyOverride(this.overriddenFamily, this.create);

  final Stream<List<String>> Function(AntennaDataStreamRef ref) create;

  @override
  final AntennaDataStreamFamily overriddenFamily;

  @override
  AntennaDataStreamProvider getProviderOverride(
    covariant AntennaDataStreamProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [antennaDataStream].
class AntennaDataStreamProvider extends StreamProvider<List<String>> {
  /// See also [antennaDataStream].
  AntennaDataStreamProvider(
    String portName,
  ) : this._internal(
          (ref) => antennaDataStream(
            ref as AntennaDataStreamRef,
            portName,
          ),
          from: antennaDataStreamProvider,
          name: r'antennaDataStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$antennaDataStreamHash,
          dependencies: AntennaDataStreamFamily._dependencies,
          allTransitiveDependencies:
              AntennaDataStreamFamily._allTransitiveDependencies,
          portName: portName,
        );

  AntennaDataStreamProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.portName,
  }) : super.internal();

  final String portName;

  @override
  Override overrideWith(
    Stream<List<String>> Function(AntennaDataStreamRef ref) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AntennaDataStreamProvider._internal(
        (ref) => create(ref as AntennaDataStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        portName: portName,
      ),
    );
  }

  @override
  (String,) get argument {
    return (portName,);
  }

  @override
  StreamProviderElement<List<String>> createElement() {
    return _AntennaDataStreamProviderElement(this);
  }

  AntennaDataStreamProvider _copyWith(
    Stream<List<String>> Function(AntennaDataStreamRef ref) create,
  ) {
    return AntennaDataStreamProvider._internal(
      (ref) => create(ref as AntennaDataStreamRef),
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      portName: portName,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AntennaDataStreamProvider && other.portName == portName;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, portName.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AntennaDataStreamRef on StreamProviderRef<List<String>> {
  /// The parameter `portName` of this provider.
  String get portName;
}

class _AntennaDataStreamProviderElement
    extends StreamProviderElement<List<String>> with AntennaDataStreamRef {
  _AntennaDataStreamProviderElement(super.provider);

  @override
  String get portName => (origin as AntennaDataStreamProvider).portName;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
