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

String _$appSettingsHash() => r'23e5cd910860b5116178d66abfa77bc128b611d2';

/// See also [AppSettings].
@ProviderFor(AppSettings)
final appSettingsProvider =
    AutoDisposeNotifierProvider<AppSettings, AppSettingsCls>.internal(
  AppSettings.new,
  name: r'appSettingsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$appSettingsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AppSettings = AutoDisposeNotifier<AppSettingsCls>;
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
