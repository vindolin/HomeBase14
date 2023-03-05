// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generic_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$togglerHash() => r'138e72744acb313f8b5f18e0373d7b2a79177638';

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

abstract class _$Toggler extends BuildlessAutoDisposeNotifier<bool> {
  late final String key;

  bool build(
    String key,
  );
}

/// See also [Toggler].
@ProviderFor(Toggler)
const togglerProvider = TogglerFamily();

/// See also [Toggler].
class TogglerFamily extends Family<bool> {
  /// See also [Toggler].
  const TogglerFamily();

  /// See also [Toggler].
  TogglerProvider call(
    String key,
  ) {
    return TogglerProvider(
      key,
    );
  }

  @override
  TogglerProvider getProviderOverride(
    covariant TogglerProvider provider,
  ) {
    return call(
      provider.key,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'togglerProvider';
}

/// See also [Toggler].
class TogglerProvider extends AutoDisposeNotifierProviderImpl<Toggler, bool> {
  /// See also [Toggler].
  TogglerProvider(
    this.key,
  ) : super.internal(
          () => Toggler()..key = key,
          from: togglerProvider,
          name: r'togglerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$togglerHash,
          dependencies: TogglerFamily._dependencies,
          allTransitiveDependencies: TogglerFamily._allTransitiveDependencies,
        );

  final String key;

  @override
  bool operator ==(Object other) {
    return other is TogglerProvider && other.key == key;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, key.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  bool runNotifierBuild(
    covariant Toggler notifier,
  ) {
    return notifier.build(
      key,
    );
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
