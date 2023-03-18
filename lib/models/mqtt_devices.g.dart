// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mqtt_devices.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$mqttMessagesHash() => r'85ebfcf87e4dff8558f974ae478b8f9fdd6e38e5';

/// See also [MqttMessages].
@ProviderFor(MqttMessages)
final mqttMessagesProvider = AutoDisposeNotifierProvider<MqttMessages,
    IMap<String, MqttMessage>>.internal(
  MqttMessages.new,
  name: r'mqttMessagesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$mqttMessagesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MqttMessages = AutoDisposeNotifier<IMap<String, MqttMessage>>;
String _$mqttMessagesFamHash() => r'a547d8eeda40913e0d5ce821b8bcad3b0dd4066e';

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

abstract class _$MqttMessagesFam extends BuildlessNotifier<dynamic> {
  late final dynamic topic;

  dynamic build(
    dynamic topic,
  );
}

/// A generic MqttMessages family provider (instead of filtering the MqttMessages with .select())
///
/// Copied from [MqttMessagesFam].
@ProviderFor(MqttMessagesFam)
const mqttMessagesFamProvider = MqttMessagesFamFamily();

/// A generic MqttMessages family provider (instead of filtering the MqttMessages with .select())
///
/// Copied from [MqttMessagesFam].
class MqttMessagesFamFamily extends Family<dynamic> {
  /// A generic MqttMessages family provider (instead of filtering the MqttMessages with .select())
  ///
  /// Copied from [MqttMessagesFam].
  const MqttMessagesFamFamily();

  /// A generic MqttMessages family provider (instead of filtering the MqttMessages with .select())
  ///
  /// Copied from [MqttMessagesFam].
  MqttMessagesFamProvider call(
    dynamic topic,
  ) {
    return MqttMessagesFamProvider(
      topic,
    );
  }

  @override
  MqttMessagesFamProvider getProviderOverride(
    covariant MqttMessagesFamProvider provider,
  ) {
    return call(
      provider.topic,
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
  String? get name => r'mqttMessagesFamProvider';
}

/// A generic MqttMessages family provider (instead of filtering the MqttMessages with .select())
///
/// Copied from [MqttMessagesFam].
class MqttMessagesFamProvider
    extends NotifierProviderImpl<MqttMessagesFam, dynamic> {
  /// A generic MqttMessages family provider (instead of filtering the MqttMessages with .select())
  ///
  /// Copied from [MqttMessagesFam].
  MqttMessagesFamProvider(
    this.topic,
  ) : super.internal(
          () => MqttMessagesFam()..topic = topic,
          from: mqttMessagesFamProvider,
          name: r'mqttMessagesFamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$mqttMessagesFamHash,
          dependencies: MqttMessagesFamFamily._dependencies,
          allTransitiveDependencies:
              MqttMessagesFamFamily._allTransitiveDependencies,
        );

  final dynamic topic;

  @override
  bool operator ==(Object other) {
    return other is MqttMessagesFamProvider && other.topic == topic;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, topic.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  dynamic runNotifierBuild(
    covariant MqttMessagesFam notifier,
  ) {
    return notifier.build(
      topic,
    );
  }
}

String _$deviceNamesHash() => r'4dbde2b23b949a59799b019b82263235704c62be';

/// See also [DeviceNames].
@ProviderFor(DeviceNames)
final deviceNamesProvider =
    NotifierProvider<DeviceNames, IMap<String, String>>.internal(
  DeviceNames.new,
  name: r'deviceNamesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$deviceNamesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DeviceNames = Notifier<IMap<String, String>>;
String _$prusaHash() => r'34a35466150cdc5f0cc8475c094b60f79e0502e1';

/// See also [Prusa].
@ProviderFor(Prusa)
final prusaProvider =
    AutoDisposeNotifierProvider<Prusa, IMap<String, dynamic>>.internal(
  Prusa.new,
  name: r'prusaProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$prusaHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Prusa = AutoDisposeNotifier<IMap<String, dynamic>>;
String _$singleCurtainDevicesHash() =>
    r'4de6d46b069d920055290f613ef4b3f2efeebc7d';

/// See also [SingleCurtainDevices].
@ProviderFor(SingleCurtainDevices)
final singleCurtainDevicesProvider = AutoDisposeNotifierProvider<
    SingleCurtainDevices, IMap<String, SingleCurtainDevice>>.internal(
  SingleCurtainDevices.new,
  name: r'singleCurtainDevicesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$singleCurtainDevicesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SingleCurtainDevices
    = AutoDisposeNotifier<IMap<String, SingleCurtainDevice>>;
String _$switchDevicesHash() => r'4c6c178ba9d67434f7d3437234e7eb467c52c1ab';

/// See also [SwitchDevices].
@ProviderFor(SwitchDevices)
final switchDevicesProvider = AutoDisposeNotifierProvider<SwitchDevices,
    IMap<String, ArmedSwitchDevice>>.internal(
  SwitchDevices.new,
  name: r'switchDevicesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$switchDevicesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SwitchDevices = AutoDisposeNotifier<IMap<String, ArmedSwitchDevice>>;
String _$lightDevicesHash() => r'99f8ff5cfea3d7809238e66e6856bf3b5218d252';

/// See also [LightDevices].
@ProviderFor(LightDevices)
final lightDevicesProvider = AutoDisposeNotifierProvider<LightDevices,
    IMap<String, LightDevice>>.internal(
  LightDevices.new,
  name: r'lightDevicesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$lightDevicesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LightDevices = AutoDisposeNotifier<IMap<String, LightDevice>>;
String _$dualCurtainDevicesHash() =>
    r'b2594191eecaa4f08ced15324cb469de6feeafce';

/// See also [DualCurtainDevices].
@ProviderFor(DualCurtainDevices)
final dualCurtainDevicesProvider = AutoDisposeNotifierProvider<
    DualCurtainDevices, IMap<String, DualCurtainDevice>>.internal(
  DualCurtainDevices.new,
  name: r'dualCurtainDevicesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dualCurtainDevicesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DualCurtainDevices
    = AutoDisposeNotifier<IMap<String, DualCurtainDevice>>;
String _$doorDevicesHash() => r'a85789b5d0a0e6e5cff59e51d57c31b0e6b8431b';

/// See also [DoorDevices].
@ProviderFor(DoorDevices)
final doorDevicesProvider =
    AutoDisposeNotifierProvider<DoorDevices, IMap<String, DoorDevice>>.internal(
  DoorDevices.new,
  name: r'doorDevicesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$doorDevicesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DoorDevices = AutoDisposeNotifier<IMap<String, DoorDevice>>;
String _$thermostatDevicesHash() => r'cf792b175503e4bc55a5823c457c016ad695c7a0';

/// See also [ThermostatDevices].
@ProviderFor(ThermostatDevices)
final thermostatDevicesProvider = AutoDisposeNotifierProvider<ThermostatDevices,
    IMap<String, ThermostatDevice>>.internal(
  ThermostatDevices.new,
  name: r'thermostatDevicesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$thermostatDevicesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ThermostatDevices
    = AutoDisposeNotifier<IMap<String, ThermostatDevice>>;
String _$smartBulbDevicesHash() => r'4b7988a9394f2ef5005f659f9da878e30083e9c1';

/// See also [SmartBulbDevices].
@ProviderFor(SmartBulbDevices)
final smartBulbDevicesProvider =
    NotifierProvider<SmartBulbDevices, IMap<String, SmartBulbDevice>>.internal(
  SmartBulbDevices.new,
  name: r'smartBulbDevicesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$smartBulbDevicesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SmartBulbDevices = Notifier<IMap<String, SmartBulbDevice>>;
String _$humiTempDevicesHash() => r'5f2d3f4d9f6f2b063556ebb39971dfffc4df4596';

/// See also [HumiTempDevices].
@ProviderFor(HumiTempDevices)
final humiTempDevicesProvider =
    NotifierProvider<HumiTempDevices, IMap<String, HumiTempDevice>>.internal(
  HumiTempDevices.new,
  name: r'humiTempDevicesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$humiTempDevicesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$HumiTempDevices = Notifier<IMap<String, HumiTempDevice>>;
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
