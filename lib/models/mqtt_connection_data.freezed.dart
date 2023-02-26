// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mqtt_connection_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

MqttConnectionDataClass _$MqttConnectionDataClassFromJson(
    Map<String, dynamic> json) {
  return _MqttConnectionData.fromJson(json);
}

/// @nodoc
mixin _$MqttConnectionDataClass {
  String get mqttUsername => throw _privateConstructorUsedError;
  String get mqttPassword => throw _privateConstructorUsedError;
  String get mqttAddress => throw _privateConstructorUsedError;
  int get mqttPort => throw _privateConstructorUsedError;
  bool get valid => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MqttConnectionDataClassCopyWith<MqttConnectionDataClass> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MqttConnectionDataClassCopyWith<$Res> {
  factory $MqttConnectionDataClassCopyWith(MqttConnectionDataClass value,
          $Res Function(MqttConnectionDataClass) then) =
      _$MqttConnectionDataClassCopyWithImpl<$Res, MqttConnectionDataClass>;
  @useResult
  $Res call(
      {String mqttUsername,
      String mqttPassword,
      String mqttAddress,
      int mqttPort,
      bool valid});
}

/// @nodoc
class _$MqttConnectionDataClassCopyWithImpl<$Res,
        $Val extends MqttConnectionDataClass>
    implements $MqttConnectionDataClassCopyWith<$Res> {
  _$MqttConnectionDataClassCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mqttUsername = null,
    Object? mqttPassword = null,
    Object? mqttAddress = null,
    Object? mqttPort = null,
    Object? valid = null,
  }) {
    return _then(_value.copyWith(
      mqttUsername: null == mqttUsername
          ? _value.mqttUsername
          : mqttUsername // ignore: cast_nullable_to_non_nullable
              as String,
      mqttPassword: null == mqttPassword
          ? _value.mqttPassword
          : mqttPassword // ignore: cast_nullable_to_non_nullable
              as String,
      mqttAddress: null == mqttAddress
          ? _value.mqttAddress
          : mqttAddress // ignore: cast_nullable_to_non_nullable
              as String,
      mqttPort: null == mqttPort
          ? _value.mqttPort
          : mqttPort // ignore: cast_nullable_to_non_nullable
              as int,
      valid: null == valid
          ? _value.valid
          : valid // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_MqttConnectionDataCopyWith<$Res>
    implements $MqttConnectionDataClassCopyWith<$Res> {
  factory _$$_MqttConnectionDataCopyWith(_$_MqttConnectionData value,
          $Res Function(_$_MqttConnectionData) then) =
      __$$_MqttConnectionDataCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String mqttUsername,
      String mqttPassword,
      String mqttAddress,
      int mqttPort,
      bool valid});
}

/// @nodoc
class __$$_MqttConnectionDataCopyWithImpl<$Res>
    extends _$MqttConnectionDataClassCopyWithImpl<$Res, _$_MqttConnectionData>
    implements _$$_MqttConnectionDataCopyWith<$Res> {
  __$$_MqttConnectionDataCopyWithImpl(
      _$_MqttConnectionData _value, $Res Function(_$_MqttConnectionData) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mqttUsername = null,
    Object? mqttPassword = null,
    Object? mqttAddress = null,
    Object? mqttPort = null,
    Object? valid = null,
  }) {
    return _then(_$_MqttConnectionData(
      mqttUsername: null == mqttUsername
          ? _value.mqttUsername
          : mqttUsername // ignore: cast_nullable_to_non_nullable
              as String,
      mqttPassword: null == mqttPassword
          ? _value.mqttPassword
          : mqttPassword // ignore: cast_nullable_to_non_nullable
              as String,
      mqttAddress: null == mqttAddress
          ? _value.mqttAddress
          : mqttAddress // ignore: cast_nullable_to_non_nullable
              as String,
      mqttPort: null == mqttPort
          ? _value.mqttPort
          : mqttPort // ignore: cast_nullable_to_non_nullable
              as int,
      valid: null == valid
          ? _value.valid
          : valid // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_MqttConnectionData
    with DiagnosticableTreeMixin
    implements _MqttConnectionData {
  const _$_MqttConnectionData(
      {required this.mqttUsername,
      required this.mqttPassword,
      required this.mqttAddress,
      required this.mqttPort,
      required this.valid});

  factory _$_MqttConnectionData.fromJson(Map<String, dynamic> json) =>
      _$$_MqttConnectionDataFromJson(json);

  @override
  final String mqttUsername;
  @override
  final String mqttPassword;
  @override
  final String mqttAddress;
  @override
  final int mqttPort;
  @override
  final bool valid;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'MqttConnectionDataClass(mqttUsername: $mqttUsername, mqttPassword: $mqttPassword, mqttAddress: $mqttAddress, mqttPort: $mqttPort, valid: $valid)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'MqttConnectionDataClass'))
      ..add(DiagnosticsProperty('mqttUsername', mqttUsername))
      ..add(DiagnosticsProperty('mqttPassword', mqttPassword))
      ..add(DiagnosticsProperty('mqttAddress', mqttAddress))
      ..add(DiagnosticsProperty('mqttPort', mqttPort))
      ..add(DiagnosticsProperty('valid', valid));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_MqttConnectionData &&
            (identical(other.mqttUsername, mqttUsername) ||
                other.mqttUsername == mqttUsername) &&
            (identical(other.mqttPassword, mqttPassword) ||
                other.mqttPassword == mqttPassword) &&
            (identical(other.mqttAddress, mqttAddress) ||
                other.mqttAddress == mqttAddress) &&
            (identical(other.mqttPort, mqttPort) ||
                other.mqttPort == mqttPort) &&
            (identical(other.valid, valid) || other.valid == valid));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, mqttUsername, mqttPassword, mqttAddress, mqttPort, valid);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_MqttConnectionDataCopyWith<_$_MqttConnectionData> get copyWith =>
      __$$_MqttConnectionDataCopyWithImpl<_$_MqttConnectionData>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_MqttConnectionDataToJson(
      this,
    );
  }
}

abstract class _MqttConnectionData implements MqttConnectionDataClass {
  const factory _MqttConnectionData(
      {required final String mqttUsername,
      required final String mqttPassword,
      required final String mqttAddress,
      required final int mqttPort,
      required final bool valid}) = _$_MqttConnectionData;

  factory _MqttConnectionData.fromJson(Map<String, dynamic> json) =
      _$_MqttConnectionData.fromJson;

  @override
  String get mqttUsername;
  @override
  String get mqttPassword;
  @override
  String get mqttAddress;
  @override
  int get mqttPort;
  @override
  bool get valid;
  @override
  @JsonKey(ignore: true)
  _$$_MqttConnectionDataCopyWith<_$_MqttConnectionData> get copyWith =>
      throw _privateConstructorUsedError;
}
