import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import '../utils.dart';
part 'mqtt_connection_data.g.dart';
part 'mqtt_connection_data.freezed.dart';

const key = 'CBoaDQIQDBEOECEZCxgMBiAUFQwKFhg=';
final encrypter = encrypt.Encrypter(
  encrypt.AES(
    encrypt.Key.fromUtf8(key),
  ),
);
final iv = encrypt.IV.fromLength(16);
final prefs = SharedPreferences.getInstance(); // where we store the encrypted connection data

@freezed
class MqttConnectionDataClass with _$MqttConnectionDataClass {
  const factory MqttConnectionDataClass({
    required String username,
    required String password,
    required String address,
    required int port,
    required bool valid,
  }) = _MqttConnectionData;
  factory MqttConnectionDataClass.fromJson(Map<String, dynamic> json) => _$MqttConnectionDataClassFromJson(json);
}

@riverpod
class MqttConnectionDataX extends _$MqttConnectionDataX {
  @override
  MqttConnectionDataClass build() {
    return const MqttConnectionDataClass(
      username: '',
      password: '',
      address: '',
      port: 1883,
      valid: false,
    );
  }

  void setValid(bool valid) {
    state = state.copyWith(valid: valid);
  }

  void save(Map<String, dynamic> data) {
    state = state.copyWith(
      username: data['username'],
      password: data['password'],
      address: data['address'],
      port: data['port'],
    );
  }

  Future<void> persistConnectionData() async {
    log('persistConnectionData...');
    await Future.delayed(
      const Duration(milliseconds: 500),
    );

    String plainText = jsonEncode(state);
    log('plainText: $plainText');
    final encrypted = encrypter.encrypt(plainText, iv: iv);

    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('connectionData', encrypted.base64);
  }

  Future<void> loadConnectionData() async {
    log('loadConnectionData...');
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? userPref = prefs.getString('connectionData');
    String connectionData = encrypter.decrypt64(userPref!, iv: iv);
    // log('pref: $connectionData');

    try {
      state = MqttConnectionDataClass.fromJson(jsonDecode(connectionData));
      // state = state.copyWith(username: 'gunk');
    } catch (e) {
      log('Error: $e');
    }
  }

  void gunk() {
    state = state.copyWith(
      username: 'gunk!',
    );
  }
}
