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
    required int camRefreshRateWifi,
    required int camRefreshRateMobile,
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
      mqttPort: 8883,
      user: User.thomas,
      valid: false,
      onlyPortrait: true,
      showBrightness: false,
      camRefreshRateWifi: 5,
      camRefreshRateMobile: 20,
    );
  }

  // TODOs add certificate upload (currently hardcoded in mqtt_providers.dart)

  void setValid(bool valid) {
    state = state.copyWith(valid: valid);
  }

  void saveUser(User user) async {
    state = state.copyWith(
      user: user,
    );
    await persistAppSettings();
  }

  void saveOnlyPortrait(bool onlyPortrait) async {
    state = state.copyWith(
      onlyPortrait: onlyPortrait,
    );
    await persistAppSettings();
  }

  void saveShowBrightness(bool showBrightness) async {
    state = state.copyWith(
      showBrightness: showBrightness,
    );
    await persistAppSettings();
  }

  void saveCamRefreshRateWifi(int duration) {
    state = state.copyWith(
      camRefreshRateWifi: duration,
    );
  }

  void saveCamRefreshRateMobile(int duration) {
    state = state.copyWith(
      camRefreshRateMobile: duration,
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

  Future<void> persistAppSettings() async {
    log('persistSettings...');
    await Future.delayed(
      const Duration(milliseconds: 500),
    );

    String plainText = jsonEncode(state);

    // encrypt the connection data
    final encrypted = encrypter.encrypt(plainText, iv: iv);

    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('settings', encrypted.base64);
  }

  Future<void> loadAppSettings() async {
    log('loadSettings...');
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? userPref = prefs.getString('settings');
    String appSettings = encrypter.decrypt64(userPref!, iv: iv);
    // log('pref: $Settings');

    try {
      state = AppSettingsCls.fromJson(jsonDecode(appSettings));
    } catch (e) {
      log('Error: $e');
    }
  }
}
