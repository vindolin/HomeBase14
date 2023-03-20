import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

import '/utils.dart';
import 'secrets.dart';

part 'app_settings.g.dart';
part 'app_settings.freezed.dart';

enum User {
  thomas,
  mona,
}

bool onlyPortrait = true;
bool showBrightness = true;

final encrypter = encrypt.Encrypter(
  encrypt.AES(
    encrypt.Key.fromUtf8(encryptionKey),
  ),
);

final iv = encrypt.IV.fromLength(16);
final prefs = SharedPreferences.getInstance(); // where we store the encrypted connection data

@freezed
class AppSettingsCls with _$AppSettingsCls {
  const factory AppSettingsCls({
    required String mqttUsername,
    required String mqttPassword,
    required String mqttAddress,
    required int mqttPort,
    required User user,
    required bool valid,
    required bool onlyPortrait,
    required bool showBrightness,
  }) = _AppSettingsCls;
  factory AppSettingsCls.fromJson(Map<String, dynamic> json) => _$AppSettingsClsFromJson(json);
}

@riverpod
class AppSettings extends _$AppSettings {
  @override
  AppSettingsCls build() {
    return const AppSettingsCls(
      mqttUsername: '',
      mqttPassword: '',
      mqttAddress: '',
      mqttPort: 1883,
      user: User.thomas,
      valid: false,
      onlyPortrait: true,
      showBrightness: true,
    );
  }

  void setValid(bool valid) {
    state = state.copyWith(valid: valid);
  }

  void saveUser(User user) {
    state = state.copyWith(
      user: user,
    );
  }

  void saveOnlyPortrait(bool onlyPortrait) {
    state = state.copyWith(
      onlyPortrait: onlyPortrait,
    );
  }

  void saveShowBrightness(bool showBrightness) {
    state = state.copyWith(
      showBrightness: showBrightness,
    );
  }

  void saveMqttLoginForm(Map<String, dynamic> data) {
    state = state.copyWith(
      mqttUsername: data['mqttUsername'],
      mqttPassword: data['mqttPassword'],
      mqttAddress: data['mqttAddress'],
      mqttPort: data['mqttPort'],
    );
  }

  Future<void> persistConnectionData() async {
    log('persistConnectionData...');
    await Future.delayed(
      const Duration(milliseconds: 500),
    );

    String plainText = jsonEncode(state);

    // encrypt the connection data
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
      state = AppSettingsCls.fromJson(jsonDecode(connectionData));
      // state = state.copyWith(mqttUsername: 'gunk');
    } catch (e) {
      log('Error: $e');
    }
  }
}
