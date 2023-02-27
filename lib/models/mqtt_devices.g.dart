// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mqtt_devices.dart';

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

String _$SimpleMqttMessagesHash() =>
    r'cb23740b9629c1cd6944867878306158a24dd075';

/// See also [SimpleMqttMessages].
final simpleMqttMessagesProvider = AutoDisposeNotifierProvider<
    SimpleMqttMessages, Map<String, SimpleMqttMessage>>(
  SimpleMqttMessages.new,
  name: r'simpleMqttMessagesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$SimpleMqttMessagesHash,
);
typedef SimpleMqttMessagesRef
    = AutoDisposeNotifierProviderRef<Map<String, SimpleMqttMessage>>;

abstract class _$SimpleMqttMessages
    extends AutoDisposeNotifier<Map<String, SimpleMqttMessage>> {
  @override
  Map<String, SimpleMqttMessage> build();
}

String _$LeechHash() => r'44384d3e1b8a1fb231473db7b09436eef154ecb0';

/// See also [Leech].
final leechProvider = AutoDisposeNotifierProvider<Leech, Map<String, String>>(
  Leech.new,
  name: r'leechProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$LeechHash,
);
typedef LeechRef = AutoDisposeNotifierProviderRef<Map<String, String>>;

abstract class _$Leech extends AutoDisposeNotifier<Map<String, String>> {
  @override
  Map<String, String> build();
}

String _$DoorDevicesHash() => r'4d735033fc9bd89705d7f7939eff7df253b750ed';

/// See also [DoorDevices].
final doorDevicesProvider =
    AutoDisposeNotifierProvider<DoorDevices, Map<String, DoorDevice>>(
  DoorDevices.new,
  name: r'doorDevicesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$DoorDevicesHash,
);
typedef DoorDevicesRef
    = AutoDisposeNotifierProviderRef<Map<String, DoorDevice>>;

abstract class _$DoorDevices
    extends AutoDisposeNotifier<Map<String, DoorDevice>> {
  @override
  Map<String, DoorDevice> build();
}

String _$ThermostatDevicesHash() => r'989325625f1552202ada162b1af4c5e544b08f67';

/// See also [ThermostatDevices].
final thermostatDevicesProvider = AutoDisposeNotifierProvider<ThermostatDevices,
    Map<String, ThermostatDevice>>(
  ThermostatDevices.new,
  name: r'thermostatDevicesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$ThermostatDevicesHash,
);
typedef ThermostatDevicesRef
    = AutoDisposeNotifierProviderRef<Map<String, ThermostatDevice>>;

abstract class _$ThermostatDevices
    extends AutoDisposeNotifier<Map<String, ThermostatDevice>> {
  @override
  Map<String, ThermostatDevice> build();
}

String _$CurtainDevicesHash() => r'd1e6fe028ddb5b79a657fd467679ef8174d44f42';

/// See also [CurtainDevices].
final curtainDevicesProvider = AutoDisposeNotifierProvider<CurtainDevices,
    Map<String, SingleCurtainDevice>>(
  CurtainDevices.new,
  name: r'curtainDevicesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$CurtainDevicesHash,
);
typedef CurtainDevicesRef
    = AutoDisposeNotifierProviderRef<Map<String, SingleCurtainDevice>>;

abstract class _$CurtainDevices
    extends AutoDisposeNotifier<Map<String, SingleCurtainDevice>> {
  @override
  Map<String, SingleCurtainDevice> build();
}

String _$DualCurtainDevicesHash() =>
    r'70d5a22040e6a3fecfacb01d1a4f394ef17ce733';

/// See also [DualCurtainDevices].
final dualCurtainDevicesProvider = AutoDisposeNotifierProvider<
    DualCurtainDevices, Map<String, DualCurtainDevice>>(
  DualCurtainDevices.new,
  name: r'dualCurtainDevicesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$DualCurtainDevicesHash,
);
typedef DualCurtainDevicesRef
    = AutoDisposeNotifierProviderRef<Map<String, DualCurtainDevice>>;

abstract class _$DualCurtainDevices
    extends AutoDisposeNotifier<Map<String, DualCurtainDevice>> {
  @override
  Map<String, DualCurtainDevice> build();
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

String _$SwitchDevicesHash() => r'65c18d1edd09bf19c8275c75bf4858629754ec2f';

/// See also [SwitchDevices].
final switchDevicesProvider =
    AutoDisposeNotifierProvider<SwitchDevices, Map<String, ArmedSwitchDevice>>(
  SwitchDevices.new,
  name: r'switchDevicesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$SwitchDevicesHash,
);
typedef SwitchDevicesRef
    = AutoDisposeNotifierProviderRef<Map<String, ArmedSwitchDevice>>;

abstract class _$SwitchDevices
    extends AutoDisposeNotifier<Map<String, ArmedSwitchDevice>> {
  @override
  Map<String, ArmedSwitchDevice> build();
}

String _$LightDevicesHash() => r'7806a40b3377d46e15e1855a9b0f81574e9e6ebe';

/// See also [LightDevices].
final lightDevicesProvider =
    AutoDisposeNotifierProvider<LightDevices, Map<String, LightDevice>>(
  LightDevices.new,
  name: r'lightDevicesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$LightDevicesHash,
);
typedef LightDevicesRef
    = AutoDisposeNotifierProviderRef<Map<String, LightDevice>>;

abstract class _$LightDevices
    extends AutoDisposeNotifier<Map<String, LightDevice>> {
  @override
  Map<String, LightDevice> build();
}
