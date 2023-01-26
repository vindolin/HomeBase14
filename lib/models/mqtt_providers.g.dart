// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mqtt_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// ignore_for_file: avoid_private_typedef_functions, non_constant_identifier_names, subtype_of_sealed_class, invalid_use_of_internal_member, unused_element, constant_identifier_names, unnecessary_raw_strings, library_private_types_in_public_api

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

String _$MqttDevicesHash() => r'9e9f539e68948cc8d0670d10bab653b1527e2b9d';

/// See also [MqttDevices].
final mqttDevicesProvider =
    AutoDisposeNotifierProvider<MqttDevices, Map<String, dynamic>>(
  MqttDevices.new,
  name: r'mqttDevicesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$MqttDevicesHash,
);
typedef MqttDevicesRef = AutoDisposeNotifierProviderRef<Map<String, dynamic>>;

abstract class _$MqttDevices extends AutoDisposeNotifier<Map<String, dynamic>> {
  @override
  Map<String, dynamic> build();
}

String _$MqttDevicesXHash() => r'328b67f3a2ea457c7cdb850da556cbddb951de77';

/// See also [MqttDevicesX].
final mqttDevicesXProvider =
    AutoDisposeNotifierProvider<MqttDevicesX, Map<String, AbstractMqttDevice>>(
  MqttDevicesX.new,
  name: r'mqttDevicesXProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$MqttDevicesXHash,
);
typedef MqttDevicesXRef
    = AutoDisposeNotifierProviderRef<Map<String, AbstractMqttDevice>>;

abstract class _$MqttDevicesX
    extends AutoDisposeNotifier<Map<String, AbstractMqttDevice>> {
  @override
  Map<String, AbstractMqttDevice> build();
}

String _$DeviceNamesHash() => r'58600b4ff41343ac5d7d24d74470b752755f3dab';

/// See also [DeviceNames].
final deviceNamesProvider =
    AutoDisposeNotifierProvider<DeviceNames, Map<String, String>>(
  DeviceNames.new,
  name: r'deviceNamesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$DeviceNamesHash,
);
typedef DeviceNamesRef = AutoDisposeNotifierProviderRef<Map<String, String>>;

abstract class _$DeviceNames extends AutoDisposeNotifier<Map<String, String>> {
  @override
  Map<String, String> build();
}

String _$MqttHash() => r'efecec48a7db91bd1ec8d1b09ead0d839e761e4d';

/// See also [Mqtt].
final mqttProvider = AutoDisposeNotifierProvider<Mqtt, dynamic>(
  Mqtt.new,
  name: r'mqttProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$MqttHash,
);
typedef MqttRef = AutoDisposeNotifierProviderRef<dynamic>;

abstract class _$Mqtt extends AutoDisposeNotifier<dynamic> {
  @override
  dynamic build();
}

String _$MqttConnectionStateXHash() =>
    r'c35210d0c89190d352fa5ff9473e19784faf7261';

/// See also [MqttConnectionStateX].
final mqttConnectionStateXProvider =
    AutoDisposeNotifierProvider<MqttConnectionStateX, MqttConnectionState>(
  MqttConnectionStateX.new,
  name: r'mqttConnectionStateXProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$MqttConnectionStateXHash,
);
typedef MqttConnectionStateXRef
    = AutoDisposeNotifierProviderRef<MqttConnectionState>;

abstract class _$MqttConnectionStateX
    extends AutoDisposeNotifier<MqttConnectionState> {
  @override
  MqttConnectionState build();
}
