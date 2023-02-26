// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mqtt_connection_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_MqttConnectionData _$$_MqttConnectionDataFromJson(
        Map<String, dynamic> json) =>
    _$_MqttConnectionData(
      mqttUsername: json['mqttUsername'] as String,
      mqttPassword: json['mqttPassword'] as String,
      mqttAddress: json['mqttAddress'] as String,
      mqttPort: json['mqttPort'] as int,
      valid: json['valid'] as bool,
    );

Map<String, dynamic> _$$_MqttConnectionDataToJson(
        _$_MqttConnectionData instance) =>
    <String, dynamic>{
      'mqttUsername': instance.mqttUsername,
      'mqttPassword': instance.mqttPassword,
      'mqttAddress': instance.mqttAddress,
      'mqttPort': instance.mqttPort,
      'valid': instance.valid,
    };

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

String _$MqttConnectionDataXHash() =>
    r'9eb020c4ee057a9216bb74070d4dd1e49949436c';

/// See also [MqttConnectionDataX].
final mqttConnectionDataXProvider =
    AutoDisposeNotifierProvider<MqttConnectionDataX, MqttConnectionDataClass>(
  MqttConnectionDataX.new,
  name: r'mqttConnectionDataXProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$MqttConnectionDataXHash,
);
typedef MqttConnectionDataXRef
    = AutoDisposeNotifierProviderRef<MqttConnectionDataClass>;

abstract class _$MqttConnectionDataX
    extends AutoDisposeNotifier<MqttConnectionDataClass> {
  @override
  MqttConnectionDataClass build();
}
