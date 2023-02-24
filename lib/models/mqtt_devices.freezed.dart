// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mqtt_devices.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$SimpleMqttMessage {
  String get topic => throw _privateConstructorUsedError;
  String get payload => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SimpleMqttMessageCopyWith<SimpleMqttMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SimpleMqttMessageCopyWith<$Res> {
  factory $SimpleMqttMessageCopyWith(
          SimpleMqttMessage value, $Res Function(SimpleMqttMessage) then) =
      _$SimpleMqttMessageCopyWithImpl<$Res, SimpleMqttMessage>;
  @useResult
  $Res call({String topic, String payload});
}

/// @nodoc
class _$SimpleMqttMessageCopyWithImpl<$Res, $Val extends SimpleMqttMessage>
    implements $SimpleMqttMessageCopyWith<$Res> {
  _$SimpleMqttMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? topic = null,
    Object? payload = null,
  }) {
    return _then(_value.copyWith(
      topic: null == topic
          ? _value.topic
          : topic // ignore: cast_nullable_to_non_nullable
              as String,
      payload: null == payload
          ? _value.payload
          : payload // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_SimpleMqttMessageCopyWith<$Res>
    implements $SimpleMqttMessageCopyWith<$Res> {
  factory _$$_SimpleMqttMessageCopyWith(_$_SimpleMqttMessage value,
          $Res Function(_$_SimpleMqttMessage) then) =
      __$$_SimpleMqttMessageCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String topic, String payload});
}

/// @nodoc
class __$$_SimpleMqttMessageCopyWithImpl<$Res>
    extends _$SimpleMqttMessageCopyWithImpl<$Res, _$_SimpleMqttMessage>
    implements _$$_SimpleMqttMessageCopyWith<$Res> {
  __$$_SimpleMqttMessageCopyWithImpl(
      _$_SimpleMqttMessage _value, $Res Function(_$_SimpleMqttMessage) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? topic = null,
    Object? payload = null,
  }) {
    return _then(_$_SimpleMqttMessage(
      topic: null == topic
          ? _value.topic
          : topic // ignore: cast_nullable_to_non_nullable
              as String,
      payload: null == payload
          ? _value.payload
          : payload // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_SimpleMqttMessage implements _SimpleMqttMessage {
  const _$_SimpleMqttMessage({required this.topic, required this.payload});

  @override
  final String topic;
  @override
  final String payload;

  @override
  String toString() {
    return 'SimpleMqttMessage(topic: $topic, payload: $payload)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_SimpleMqttMessage &&
            (identical(other.topic, topic) || other.topic == topic) &&
            (identical(other.payload, payload) || other.payload == payload));
  }

  @override
  int get hashCode => Object.hash(runtimeType, topic, payload);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_SimpleMqttMessageCopyWith<_$_SimpleMqttMessage> get copyWith =>
      __$$_SimpleMqttMessageCopyWithImpl<_$_SimpleMqttMessage>(
          this, _$identity);
}

abstract class _SimpleMqttMessage implements SimpleMqttMessage {
  const factory _SimpleMqttMessage(
      {required final String topic,
      required final String payload}) = _$_SimpleMqttMessage;

  @override
  String get topic;
  @override
  String get payload;
  @override
  @JsonKey(ignore: true)
  _$$_SimpleMqttMessageCopyWith<_$_SimpleMqttMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ArmedSwitchDevice {
  String get topicGet => throw _privateConstructorUsedError;
  String get topicSet => throw _privateConstructorUsedError;
  String get onState => throw _privateConstructorUsedError;
  String get offState => throw _privateConstructorUsedError;
  String? get state => throw _privateConstructorUsedError;
  bool get transitioning => throw _privateConstructorUsedError;
  set transitioning(bool value) => throw _privateConstructorUsedError;
  String? get stateKey => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ArmedSwitchDeviceCopyWith<ArmedSwitchDevice> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ArmedSwitchDeviceCopyWith<$Res> {
  factory $ArmedSwitchDeviceCopyWith(
          ArmedSwitchDevice value, $Res Function(ArmedSwitchDevice) then) =
      _$ArmedSwitchDeviceCopyWithImpl<$Res, ArmedSwitchDevice>;
  @useResult
  $Res call(
      {String topicGet,
      String topicSet,
      String onState,
      String offState,
      String? state,
      bool transitioning,
      String? stateKey});
}

/// @nodoc
class _$ArmedSwitchDeviceCopyWithImpl<$Res, $Val extends ArmedSwitchDevice>
    implements $ArmedSwitchDeviceCopyWith<$Res> {
  _$ArmedSwitchDeviceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? topicGet = null,
    Object? topicSet = null,
    Object? onState = null,
    Object? offState = null,
    Object? state = freezed,
    Object? transitioning = null,
    Object? stateKey = freezed,
  }) {
    return _then(_value.copyWith(
      topicGet: null == topicGet
          ? _value.topicGet
          : topicGet // ignore: cast_nullable_to_non_nullable
              as String,
      topicSet: null == topicSet
          ? _value.topicSet
          : topicSet // ignore: cast_nullable_to_non_nullable
              as String,
      onState: null == onState
          ? _value.onState
          : onState // ignore: cast_nullable_to_non_nullable
              as String,
      offState: null == offState
          ? _value.offState
          : offState // ignore: cast_nullable_to_non_nullable
              as String,
      state: freezed == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String?,
      transitioning: null == transitioning
          ? _value.transitioning
          : transitioning // ignore: cast_nullable_to_non_nullable
              as bool,
      stateKey: freezed == stateKey
          ? _value.stateKey
          : stateKey // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_SwitchDeviceCopyWith<$Res>
    implements $ArmedSwitchDeviceCopyWith<$Res> {
  factory _$$_SwitchDeviceCopyWith(
          _$_SwitchDevice value, $Res Function(_$_SwitchDevice) then) =
      __$$_SwitchDeviceCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String topicGet,
      String topicSet,
      String onState,
      String offState,
      String? state,
      bool transitioning,
      String? stateKey});
}

/// @nodoc
class __$$_SwitchDeviceCopyWithImpl<$Res>
    extends _$ArmedSwitchDeviceCopyWithImpl<$Res, _$_SwitchDevice>
    implements _$$_SwitchDeviceCopyWith<$Res> {
  __$$_SwitchDeviceCopyWithImpl(
      _$_SwitchDevice _value, $Res Function(_$_SwitchDevice) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? topicGet = null,
    Object? topicSet = null,
    Object? onState = null,
    Object? offState = null,
    Object? state = freezed,
    Object? transitioning = null,
    Object? stateKey = freezed,
  }) {
    return _then(_$_SwitchDevice(
      topicGet: null == topicGet
          ? _value.topicGet
          : topicGet // ignore: cast_nullable_to_non_nullable
              as String,
      topicSet: null == topicSet
          ? _value.topicSet
          : topicSet // ignore: cast_nullable_to_non_nullable
              as String,
      onState: null == onState
          ? _value.onState
          : onState // ignore: cast_nullable_to_non_nullable
              as String,
      offState: null == offState
          ? _value.offState
          : offState // ignore: cast_nullable_to_non_nullable
              as String,
      state: freezed == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String?,
      transitioning: null == transitioning
          ? _value.transitioning
          : transitioning // ignore: cast_nullable_to_non_nullable
              as bool,
      stateKey: freezed == stateKey
          ? _value.stateKey
          : stateKey // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$_SwitchDevice implements _SwitchDevice {
  _$_SwitchDevice(
      {required this.topicGet,
      required this.topicSet,
      required this.onState,
      required this.offState,
      this.state = null,
      this.transitioning = false,
      this.stateKey = null});

  @override
  final String topicGet;
  @override
  final String topicSet;
  @override
  final String onState;
  @override
  final String offState;
  @override
  @JsonKey()
  final String? state;
  @override
  @JsonKey()
  bool transitioning;
  @override
  @JsonKey()
  final String? stateKey;

  @override
  String toString() {
    return 'ArmedSwitchDevice(topicGet: $topicGet, topicSet: $topicSet, onState: $onState, offState: $offState, state: $state, transitioning: $transitioning, stateKey: $stateKey)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_SwitchDeviceCopyWith<_$_SwitchDevice> get copyWith =>
      __$$_SwitchDeviceCopyWithImpl<_$_SwitchDevice>(this, _$identity);
}

abstract class _SwitchDevice implements ArmedSwitchDevice {
  factory _SwitchDevice(
      {required final String topicGet,
      required final String topicSet,
      required final String onState,
      required final String offState,
      final String? state,
      bool transitioning,
      final String? stateKey}) = _$_SwitchDevice;

  @override
  String get topicGet;
  @override
  String get topicSet;
  @override
  String get onState;
  @override
  String get offState;
  @override
  String? get state;
  @override
  bool get transitioning;
  set transitioning(bool value);
  @override
  String? get stateKey;
  @override
  @JsonKey(ignore: true)
  _$$_SwitchDeviceCopyWith<_$_SwitchDevice> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$LightDevice {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get topicGet => throw _privateConstructorUsedError;
  String get topicSet => throw _privateConstructorUsedError;
  String get state => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $LightDeviceCopyWith<LightDevice> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LightDeviceCopyWith<$Res> {
  factory $LightDeviceCopyWith(
          LightDevice value, $Res Function(LightDevice) then) =
      _$LightDeviceCopyWithImpl<$Res, LightDevice>;
  @useResult
  $Res call(
      {String id, String name, String topicGet, String topicSet, String state});
}

/// @nodoc
class _$LightDeviceCopyWithImpl<$Res, $Val extends LightDevice>
    implements $LightDeviceCopyWith<$Res> {
  _$LightDeviceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? topicGet = null,
    Object? topicSet = null,
    Object? state = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      topicGet: null == topicGet
          ? _value.topicGet
          : topicGet // ignore: cast_nullable_to_non_nullable
              as String,
      topicSet: null == topicSet
          ? _value.topicSet
          : topicSet // ignore: cast_nullable_to_non_nullable
              as String,
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_LightDeviceCopyWith<$Res>
    implements $LightDeviceCopyWith<$Res> {
  factory _$$_LightDeviceCopyWith(
          _$_LightDevice value, $Res Function(_$_LightDevice) then) =
      __$$_LightDeviceCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id, String name, String topicGet, String topicSet, String state});
}

/// @nodoc
class __$$_LightDeviceCopyWithImpl<$Res>
    extends _$LightDeviceCopyWithImpl<$Res, _$_LightDevice>
    implements _$$_LightDeviceCopyWith<$Res> {
  __$$_LightDeviceCopyWithImpl(
      _$_LightDevice _value, $Res Function(_$_LightDevice) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? topicGet = null,
    Object? topicSet = null,
    Object? state = null,
  }) {
    return _then(_$_LightDevice(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      topicGet: null == topicGet
          ? _value.topicGet
          : topicGet // ignore: cast_nullable_to_non_nullable
              as String,
      topicSet: null == topicSet
          ? _value.topicSet
          : topicSet // ignore: cast_nullable_to_non_nullable
              as String,
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_LightDevice implements _LightDevice {
  const _$_LightDevice(
      {required this.id,
      required this.name,
      required this.topicGet,
      required this.topicSet,
      required this.state});

  @override
  final String id;
  @override
  final String name;
  @override
  final String topicGet;
  @override
  final String topicSet;
  @override
  final String state;

  @override
  String toString() {
    return 'LightDevice(id: $id, name: $name, topicGet: $topicGet, topicSet: $topicSet, state: $state)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_LightDevice &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.topicGet, topicGet) ||
                other.topicGet == topicGet) &&
            (identical(other.topicSet, topicSet) ||
                other.topicSet == topicSet) &&
            (identical(other.state, state) || other.state == state));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, topicGet, topicSet, state);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_LightDeviceCopyWith<_$_LightDevice> get copyWith =>
      __$$_LightDeviceCopyWithImpl<_$_LightDevice>(this, _$identity);
}

abstract class _LightDevice implements LightDevice {
  const factory _LightDevice(
      {required final String id,
      required final String name,
      required final String topicGet,
      required final String topicSet,
      required final String state}) = _$_LightDevice;

  @override
  String get id;
  @override
  String get name;
  @override
  String get topicGet;
  @override
  String get topicSet;
  @override
  String get state;
  @override
  @JsonKey(ignore: true)
  _$$_LightDeviceCopyWith<_$_LightDevice> get copyWith =>
      throw _privateConstructorUsedError;
}
