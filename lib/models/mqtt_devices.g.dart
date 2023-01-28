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
