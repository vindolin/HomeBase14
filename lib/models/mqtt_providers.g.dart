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

String _$CurtainDevicesHash() => r'b33f41e5ba1de1ab0e7209988373e60808988fb2';

/// See also [CurtainDevices].
final curtainDevicesProvider =
    AutoDisposeNotifierProvider<CurtainDevices, Map<String, CurtainDevice>>(
  CurtainDevices.new,
  name: r'curtainDevicesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$CurtainDevicesHash,
);
typedef CurtainDevicesRef
    = AutoDisposeNotifierProviderRef<Map<String, CurtainDevice>>;

abstract class _$CurtainDevices
    extends AutoDisposeNotifier<Map<String, CurtainDevice>> {
  @override
  Map<String, CurtainDevice> build();
}

String _$MqttHash() => r'6542290b125cb274721db826628bc294f60f5b43';

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
