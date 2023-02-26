// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_AppSettingsCls _$$_AppSettingsClsFromJson(Map<String, dynamic> json) =>
    _$_AppSettingsCls(
      mqttUsername: json['mqttUsername'] as String,
      mqttPassword: json['mqttPassword'] as String,
      mqttAddress: json['mqttAddress'] as String,
      mqttPort: json['mqttPort'] as int,
      user: $enumDecode(_$UserEnumMap, json['user']),
      valid: json['valid'] as bool,
    );

Map<String, dynamic> _$$_AppSettingsClsToJson(_$_AppSettingsCls instance) =>
    <String, dynamic>{
      'mqttUsername': instance.mqttUsername,
      'mqttPassword': instance.mqttPassword,
      'mqttAddress': instance.mqttAddress,
      'mqttPort': instance.mqttPort,
      'user': _$UserEnumMap[instance.user]!,
      'valid': instance.valid,
    };

const _$UserEnumMap = {
  User.thomas: 'thomas',
  User.mona: 'mona',
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

String _$AppSettingsHash() => r'23e5cd910860b5116178d66abfa77bc128b611d2';

/// See also [AppSettings].
final appSettingsProvider =
    AutoDisposeNotifierProvider<AppSettings, AppSettingsCls>(
  AppSettings.new,
  name: r'appSettingsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$AppSettingsHash,
);
typedef AppSettingsRef = AutoDisposeNotifierProviderRef<AppSettingsCls>;

abstract class _$AppSettings extends AutoDisposeNotifier<AppSettingsCls> {
  @override
  AppSettingsCls build();
}
